module API
  module Version1
    # Authenticate helpers for resources
    module Helpers
      def warden
        @warden ||= request.env['warden']
      end

      def current_user
        @user ||= warden.user(:person)
      end

      def user_loged_in?
        warden.authenticated?(:person)
      end

      def authenticate_by_token!
        env['devise.skip_trackable'] = true
        warden.authenticate!(:token_authentication, scope: :person)
      end

      def client_ip
        env['action_dispatch.remote_ip'].to_s
      end
    end

    # Module for extend in resources to accept token headers
    module ParamsHelper
      def auth_parameters
        {
          'X_AUTH_TOKEN' => {
            description: 'User token',
            required: true
          }
        }
      end
    end
  end
end
