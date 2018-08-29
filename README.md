# firebase-auth-rails


This is a plugin that performs firebase authentication in rails.

Made influenced by [firebase_id_token](https://github.com/fschuindt/firebase_id_token) and [knock](https://github.com/nsarno/knock)

Thanks to the author.


## Status
Now it's a beta version.
Only login feature is available.
It does not have firebase user creation feature.

## Usage
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

The following method is recommended until beta version

```ruby
gem 'firebase-auth-rails', github: 'penguinwokrs/firebase-auth-rails'
gem 'firebase_id_token', github: 'penguinwokrs/firebase_id_token'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install firebase-auth-rails
```

## Testing
There is preparation for testing firebase certification.
Please click here. [link](https://github.com/fschuindt/firebase_id_token#user-content-development)

## Contributing
We welcome PR.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
