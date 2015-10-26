require 'grape'

module API
  module Version1
    class Sessions < ::Grape::API
      version 'v1', using: :path

      resource :sessions do
        desc 'Get auth token'
        get '/' do  
        end

        desc 'Remove auth tokern'
        params do
          requires :token, type: String, desc: 'Auth token to delete from usage'
        end
        delete '/' do
          params[:token]
        end
      end
    end
  end
end