require 'grape'

module API
  module Version1
    class Sessions < ::Grape::API
      version 'v1', using: :path

      resource :sessions do
        desc 'Get auth token'
        params do
          requires :email, type: String, desc: 'Email address'
          requires :password, type: String, desc: 'Password'
        end
        get '/' do  
          _user = Person.where(email: params[:email].downcase).first

          if _user && _user.valid_password?(params[:password])
            _token = Person.generate_authentication_token
            _user.authentication_token = _token
            _user.save

            {token: _token}
          else
            error!('Unauthoraized.', 401)
          end
        end

        desc 'Remove auth token'
        params do
          requires :access_token, type: String, desc: 'Auth token to delete from usage'
        end
        delete '/' do
          authenticate!
          _user = Person.where(authentication_token: params[:access_token]).first
          _user.authentication_token = nil
          _user.save
        end
      end
    end
  end
end