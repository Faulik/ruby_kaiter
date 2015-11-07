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

        desc 'Return all rations in sprint for user', headers: auth_parameters
        get '/:id/rations' do
          authenticate_by_token!
          DailyRation.includes(:dish)
                     .where(sprint_id: params[:id], 
                            person_id: current_user.id)
                     .as_json(include: :dish)
        end
      end
    end
  end
end
