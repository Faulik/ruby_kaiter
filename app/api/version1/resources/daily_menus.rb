require 'grape'

module API
  module Version1
    class DailyMenus < ::Grape::API
      version 'v1', using: :path

      resource :daily_menus do
        desc 'Return all daily menus with dishes id\'s'
        get '/' do
          _daily_menus = DailyMenu.order(id: :asc).all.as_json()
          _dishes = Dish.includes(:category)
          _daily_menus.each do |_dm|
            _dm['dishes'] = _dishes.select { |item| _dm['dish_ids'].include?(item.id) }
                                   .as_json(include: :category)
          end
          _daily_menus
        end
      end
    end
  end
end