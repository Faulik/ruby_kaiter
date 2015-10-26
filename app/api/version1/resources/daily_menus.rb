require 'grape'

module API
  module Version1
    class DailyMenus < ::Grape::API
      version 'v1', using: :path

      resource :daily_menus do
        desc 'Return all daily menus with dishes id\'s'
        get '/' do
          DailyMenu.order(id: :asc).all
        end
      end
    end
  end
end