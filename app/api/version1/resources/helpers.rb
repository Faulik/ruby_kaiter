module API
  module Version1
    module Helpers
      def warden
        @warden ||= request.env["warden"]
      end

      def authenticate!
        error!('Unauthorized. Invalid token.', 401) unless authenticate_by_token
      end

      def authenticate_by_token
        _user_token = params[:access_token].presence
        _user = _user_token && Person.where(authentication_token: _user_token)

        if _user
          true
        else
          false
        end
      end

      def client_ip
        env["action_dispatch.remote_ip"].to_s
      end
    end
  end
end
