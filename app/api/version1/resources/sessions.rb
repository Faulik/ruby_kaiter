require 'grape'
require 'json'

module API
  module Version1
    class Sessions < ::Grape::API
      version 'v1', using: :path
      format :json
      content_type :json, 'applications/json'

      extend API::Version1::ParamsHelper

      resource :sessions do
        desc 'Get auth token'
        params do
          requires :auth, type: Hash do
            requires :email, type: String, desc: 'Email address'
            requires :password, type: String, desc: 'Password'
          end
        end
        post '/' do
          _user = Person.where(email: params[:auth][:email].downcase).first

          if _user && _user.valid_password?(params[:auth][:password])
            _token = Person.generate_authentication_token
            _user.authentication_token = _token
            _user.save

            { auth: true, email: _user.email, name: _user.name, token: _token }
          else
            error!('Unauthoraized.', 401)
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

          _user = current_user
          _user.authentication_token = nil
          _user.save
          
          { result: 'Success!' }
        end
      end
    end
  end
end
