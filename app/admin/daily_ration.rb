ActiveAdmin.register DailyRation do
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
  end
end
