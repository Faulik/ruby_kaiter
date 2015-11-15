require 'grape'
require 'pry'

module API
  module Version1
    class DailyRations < ::Grape::API
      version 'v1', using: :path

      resource :daily_rations do
        desc 'Save all rations'
        params do
          requires :rations, type: Array do
            requires :daily_menu_id, type: Integer, desc: 'Daily menu id'
            requires :dish_id, type: Integer, desc: 'Dish id'
            requires :sprint_id, type: Integer, desc: 'Id of spint'
            requires :quantity, type: Integer, desc: 'Quantity of dishes in ration'
          end          
        end
        post '/' do
          @rations = RationsUpdater.new(params[:rations], current_user)
          
          {result: @rations.save}
        end
      end
    end
  end
end