ActiveAdmin.register DailyMenu do
  permit_params :day_number,
                :max_total,
                dish_ids: []

  # Index page
  index do
    selectable_column
    column :id
    column :day_number
    column :max_total
    column 'Dishes' do |menu|
      _dishes = Dish.find(menu.dish_ids).map do |dish|
        if dish.type == 'Meal'
          link_to dish.title, admin_meal_path(dish)
        else
          link_to dish.title, admin_bussines_dish_path(dish)
        end
      end
      raw(_dishes.join(', '))
    end
    actions
  end

  # Show page
  show do
    panel 'Daily Menu Details' do
      attributes_table_for daily_menu do
        row('id') { daily_menu.id }
        row('day_number') { daily_menu.day_number }
        row('max_total') { daily_menu.max_total }
      end
    end

    # All dishes in menu
    panel 'Dishes' do
      table_for Dish.find(daily_menu.dish_ids) do
        column :id
        column 'title' do |dish|
          if dish.type == 'Meal'
            link_to dish.title, admin_meal_path(dish)
          else
            link_to dish.title, admin_bussines_dish_path(dish)
          end
        end
        column 'Type' do |dish|
          status_tag (dish.type == 'Meal' ? 'Meal' : 'Bussines Dish'),
                     (dish.type == 'Meal' ? :ok : :yes)
        end
      end
    end
  end

  # Update and create form
  form do |f|
    f.inputs 'Daily Menu' do
      f.input :day_number
      f.input :max_total
    end

    f.inputs 'Dishes' do
      f.input :dish_ids,
              label: 'Dishes',
              as: :select,
              multiple: true,
              collection: option_groups_from_collection_for_select(Category.includes(:dishes).where(dishes: { type: 'Meal' }), :dishes, :title, :id, :title),
              input_html: { class: 'select2-list' }
    end
    f.actions
  end

  # Fixes blank item in select2
  controller do
    def create
      _params = permitted_params['daily_menu']
      _params['dish_ids'].reject!(&:empty?)
      _menu = DailyMenu.new(_params)
      if _menu.save
        redirect_to admin_daily_menus_path
      else
        redirect_to new_admin_daily_menu_path, alert: 'Something went wrong'
      end
    end

    def update
      _menu = DailyMenu.find(params[:id])
      _params = permitted_params['daily_menu']
      _params['dish_ids'].reject!(&:empty?)
      if _menu.update(_params)
        redirect_to admin_daily_menu_path(_menu)
      else
        redirect_to edit_admin_daily_menu_path, alert: 'Something went wrong'
      end
    end
  end
end
