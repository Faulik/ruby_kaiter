module TokenAuthentication
  class CustomStrategy < Devise::Strategies::Authenticatable
    def valid?
      request.headers['HTTP_X_AUTH_TOKEN'].present?
    end

    def authenticate!
      if request.headers['HTTP_X_AUTH_TOKEN'].present?
        # the returned user object will be saved and serialised into the session
        user = Person.where(authentication_token: request.headers['HTTP_X_AUTH_TOKEN']).first
        if user.nil?
          throw(:warden, message: 'Could not login with this credentials')
        else
          success! user
        end
      end
    end

    private

    def deny!
      body = %(This is an unauthorised request. Your IP address has been logged and will be reported.)
      response_headers = { 'Content-Type' => 'text/plain' }
      response = Rack::Response.new(body, 400, response_headers)
      custom! response.finish
    end
  end
end

Warden::Strategies.add :token_authentication, TokenAuthentication::CustomStrategy

Devise.add_module :token_authentication, strategy: true
