require 'grape'

module API
  module Version1
    class Sprints < ::Grape::API
      version 'v1', using: :path
      
      resource :sprints do
        desc 'Return all sprints'
        get '/' do
          Sprint.order(id: :asc).all
        end

        desc 'Return all rations of sprint'
        get '/:id/rations' do
          DailyRation.where(sprint_id: params[:id])
        end
      end
    end
  end
end