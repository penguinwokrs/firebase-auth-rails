# firebase-auth-rails


This is a plugin that performs firebase authentication in rails.

[![Gem Version](https://badge.fury.io/rb/firebase-auth-rails.svg)](https://badge.fury.io/rb/firebase-auth-rails)
[![Build Status](https://travis-ci.org/penguinwokrs/firebase-auth-rails.svg?branch=master)](https://travis-ci.org/penguinwokrs/firebase-auth-rails)
[![Maintainability](https://api.codeclimate.com/v1/badges/42c3a31a589213a5b82b/maintainability)](https://codeclimate.com/github/penguinwokrs/aws-transcoder-rails/maintainability)

Supported Rails version is 5.x, 6.0

As of version 4.2, the test environment is not ready and I do not know if it will work.


Made influenced by [firebase_id_token](https://github.com/fschuindt/firebase_id_token) and [knock](https://github.com/nsarno/knock)

Thanks to the author.

## Status
Now it's a beta version.
Only login feature is available.
It does not have firebase user creation feature.

## Usage
Add database migrate method.

```ruby
class AddUidToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :uid, :string
  end
end
```

Add the following code to the controller to use.

```ruby
include Firebase::Auth::Authenticable
before_action :authenticate_user
```

The current user is defined
``` ruby
current_user.user_name
# => yamada
```

The following is a generic user creation code

* api/v1/application_controller

```ruby
module Api
  class V1::ApplicationController < ActionController::API
    include Firebase::Auth::Authenticable
    before_action :authenticate_user
  end
end
```

* api/v1/auth/registrations_controller
```ruby

require_dependency 'api/v1/application_controller'
module Api
  module V1
    module Auth
      class RegistrationsController < V1::ApplicationController
        skip_before_action :authenticate_user

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
  end
end

```

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

## initializer
```ruby
# frozen_string_literal: true

FirebaseIdToken.configure do |config|
  config.redis = Redis.new
  config.project_ids = ['firebase_project_id']
end

```

## Testing
There is preparation for testing firebase certification.
Please click here. [link](https://github.com/fschuindt/firebase_id_token#user-content-development)

## Contributing
We welcome PR.


## development
### getting started

* Test preparation

```bash
cd test/dummy/
bin/rails migrate
```

* The test is a minitest
```bash
# Project root dir
rake test
```

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
