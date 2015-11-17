require 'action_dispatch/middleware/remote_ip.rb'
require 'version1/resources/helpers'
require 'version1/resources/sessions'
require 'version1/resources/sprints'
require 'version1/resources/daily_menus'
require 'version1/resources/daily_rations'

module API
  module Version1

    class Engine < ::Grape::API
      format :json
      default_format :json
      default_error_formatter :json
      content_type :json, 'application/json'
      version 'v1', using: :path

      use ActionDispatch::RemoteIp

      helpers API::Version1::Helpers

      mount API::Version1::Sessions
      mount API::Version1::Sprints
      mount API::Version1::DailyMenus
      mount API::Version1::DailyRations

      add_swagger_documentation base_path: '/api', hide_documentation_path: true, api_version: 'v1'

      get '/' do
        { timenow: Time.zone.now.to_i }
      end
    end
  end
end
