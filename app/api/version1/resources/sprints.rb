require 'grape'

module API
  module Version1
    class Sprints < ::Grape::API
      version 'v1', using: :path

      extend API::Version1::ParamsHelper

      resource :sprints do
        desc 'Return all sprints', headers: auth_parameters
        get '/' do
          authenticate_by_token!
          Sprint.order(id: :asc).all
        end

        desc 'Return all rations of sprint', headers: auth_parameters
        get '/:id/rations' do
          authenticate_by_token!
          DailyRation.where(sprint_id: params[:id])
        end
      end
    end
  end
end
