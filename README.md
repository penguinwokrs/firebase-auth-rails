# firebase-auth-rails

A gem for handling Firebase authentication in Ruby on Rails 5+.

[![Gem Version](https://badge.fury.io/rb/firebase-auth-rails.svg)](https://badge.fury.io/rb/firebase-auth-rails)
[![Build Status](https://travis-ci.org/penguinwokrs/firebase-auth-rails.svg?branch=master)](https://travis-ci.org/penguinwokrs/firebase-auth-rails)
[![Maintainability](https://api.codeclimate.com/v1/badges/42c3a31a589213a5b82b/maintainability)](https://codeclimate.com/github/penguinwokrs/aws-transcoder-rails/maintainability)

This project was inspired and influenced by [firebase_id_token](https://github.com/fschuindt/firebase_id_token) and [knock](https://github.com/nsarno/knock). Thanks to the authors of those projects!

## Current Development Status

- This is a beta version only

- The only feature avaialable at this time is "login"; Firebase's user creation is *not* supported at this time.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'firebase-auth-rails'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install firebase-auth-rails
```

## Setup

**NOTE:** A lot if not all of the following can and should be automated in a generic "install" generator, in the future. For now, though there is some setup you'll have to do yourself...

1. First, create a file `config/initializers/firebase_auth_initializer.rb`, and add the following. You'll need to deal with setting up Redis and replacing your project ID, and so on

```ruby
FirebaseIdToken.configure do |config|
  config.redis = Redis.new
  config.project_ids = ['firebase_project_id']
end
```

2. You need to have a `uid` string column, so go ahead and generate a migration for that

```bash
rails g migration AddUidToUsers uid:string
```

You should end up with a file `db/migrate/xxxxxxxxxxxxxx_add_uid_to_users.rb`, with contents something like

```ruby
class AddUidToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :uid, :string
  end
end
```

Run the migrations

```bash
rails db:migrate
```

3. In your `ApplicationController`, include the `Authenticable` module

```ruby
include Firebase::Auth::Authenticable
```

Now you could, for instance, use a `before_action` to perform authentication before any controller action

```ruby
before_action :authenticate_user
```

4. Test it out!

Assuming everything is set up correctly at this point, you should be able to access the current user!

``` ruby
current_user.user_name
# => yamada
```

## Example Code

Below is all the code you need to implement a very basic authentication system, including sign up.

* app/controllers/application_controller

```ruby
class ApplicationController < ActionController::Base
  # We need to include the gem's main module to do anything...
  #
  include Firebase::Auth::Authenticable

  # Let's assume everything is protected by performing the `authenticate_user`
  # method before any controller action. We can skip this where needed.
  #
  before_action :authenticate_user
end
```

* api/controllers/users/registrations_controller

```ruby
module Users
  class RegistrationsController < ApplicationController
    # We don't want to try and authenticate a user who is trying to sign up!
    # This is how we skip the authentication, like mentioned earlier.
    #
    skip_before_action :authenticate_user

    # TODO: Not sure exactly what is meant to be going on here
    # I assume it's expecting a POST request from Firebase?
    #
    # Hopefully someone can come in and clear this up better in the future.
    #
    def create
      raise ArgumentError, 'BadRequest Parameter' if payload.blank?
      user = User.create!(sign_up_params.merge(uid: payload['sub']))
      render json: user, serializer: V1::AuthSerializer, status: :ok
    end

    private

    def sign_up_params
      params.require(:registration).permit(:user_name, :display_name)
    end

    def token_from_request_headers
      request.headers['Authorization']&.split&.last
    end

    def token
      params[:token] || token_from_request_headers
    end

    def payload
      @payload ||= FirebaseIdToken::Signature.verify token
    end
  end
end
```

## Testing

1. Run migrations for Rails test dummy

```bash
cd test/dummy/
bin/rails migrate
```

2. `FirebaseIdToken` setup: see [this link](https://github.com/fschuindt/firebase_id_token#user-content-development) for details

3. Run the tests w/ Rake!

```bash
rake test
```

## Contributing
We welcome PRs!

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
