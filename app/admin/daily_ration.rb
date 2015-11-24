ActiveAdmin.register DailyRation do
  permit_params :price, :quantity, :person_id, :daily_menu_id, :sprint_id, :dish_id

  # Index page
  index do
    column :id
    column :price
    column :quantity
    column 'person_id' do |dr|
      link_to dr.person.name, admin_person_path(dr.person)
    end
    column 'Day' do |dr|
      link_to dr.daily_menu.id, admin_daily_menu_path(dr.daily_menu)
    end
    column 'Sprint' do |dr|
      link_to dr.sprint.title, admin_sprint_path(dr.sprint)
    end
    column 'Dish' do |dr|
      link_to dr.dish.title, admin_dish_path(dr.dish)
    end
    actions
  end

  # Update and create page
  form do |f|
    f.inputs 'Meal' do
      f.input :price
      f.input :dish_id,
              as: :select,
              include_blank: false,
              collection: Dish.all
      f.input :sprint_id,
              as: :select,
              include_blank: false,
              collection: Sprint.all
      f.input :person_id,
              as: :select,
              include_blank: false,
              collection: Person.all
      f.input :daily_menu_id,
              as: :select,
              include_blank: false,
              collection: DailyMenu.all
    end

    f.actions
  end
end
