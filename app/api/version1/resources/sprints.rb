require 'grape'

module API
  module Version1
    # Endpoint to serve sprint information and update sprint rations
    class Sprints < ::Grape::API
      version 'v1', using: :path

      extend API::Version1::ParamsHelper

      resource :sprints do
        desc 'Return all sprints', headers: auth_parameters
        get '/' do
          authenticate_by_token!

          Sprint.order(id: :asc).all
        end

        desc 'Return specific sprint', headers: auth_parameters
        get '/:id' do
          authenticate_by_token!

          Sprint.find(params[:id])
        end

        desc 'Return all rations in sprint for user', headers: auth_parameters
        get '/:id/rations' do
          authenticate_by_token!

          DailyRation.includes(:dish)
            .where(sprint_id: params[:id],
                   person_id: current_user.id)
            .as_json(include: :dish)
        end

        desc 'Save array of rations'
        params do
          requires :rations, type: Array do
            requires :daily_menu_id, type: Integer, desc: 'Daily menu id'
            requires :dish_id, type: Integer, desc: 'Dish id'
            requires :sprint_id, type: Integer, desc: 'Id of spint'
            requires :quantity, type: Integer, desc: 'Quantity of dishes in ration'
            requires :price, type: Integer, desc: 'Price of dish in ration'
          end
        end
        post '/:id/rations' do
          authenticate_by_token!

          @rations = RationsUpdater.new(params[:rations], current_user)

          { result: @rations.save }
        end
      end
    end
  end
end
