module TokenAuthentication
  class CustomStrategy < Devise::Strategies::Authenticatable
    def valid?
      request.headers['HTTP_X_AUTH_TOKEN'].present?
    end

    def authenticate!
      # the returned user object will be saved and serialised into the session
      user = Person.where(authentication_token: request.headers['HTTP_X_AUTH_TOKEN']).first
      if user.nil?
        fail!('No such user.')
      else
        success! user
      end
    end
  end
end

Warden::Strategies.add :token_authentication, TokenAuthentication::CustomStrategy

Devise.add_module :token_authentication, strategy: true
