require 'grape'
require 'json'

module API
  module Version1
    # Endpoint for authentication
    class Sessions < ::Grape::API
      version 'v1', using: :path

      extend API::Version1::ParamsHelper

      resource :sessions do
        desc 'Get auth token'
        params do
          requires :auth, type: Hash do
            requires :email, type: String, desc: 'User email address'
            requires :password, type: String, desc: 'User password'
          end
        end
        post '/' do
          _user = Person.find_by email: params[:auth][:email].downcase

          if _user && _user.valid_password?(params[:auth][:password])
            _user.set_new_token

            {
              auth: true,
              email: _user.email,
              name: _user.name,
              token: _user.authentication_token
            }
          else
            error!('Invalid login credentials', 422)
          end
        end

        desc 'Auth with token'
        get '/' do
          authenticate_by_token!

          _user = current_user

          { auth: true,
            email: _user.email,
            name: _user.name,
            token: _user.authentication_token }
        end

        desc 'Remove auth token', headers: auth_parameters
        delete '/' do
          authenticate_by_token!

          current_user.destroy_token

          { result: 'Success!' }
        end
      end
    end
  end
end
