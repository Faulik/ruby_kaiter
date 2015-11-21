ActiveAdmin.register DailyRation do
  index do
    column :id
    column :price
    column :quantity
    column 'person_id' do |dr|
      _person = Person.find(dr.person_id)
      link_to _person.name, admin_people_path(dr.person_id)
    end
    column 'Day' do |dr|
      link_to dr.daily_menu_id, admin_daily_menu_path(dr.daily_menu_id)
    end
    column 'Sprint' do |dr|
      _sprint = Sprint.find(dr.sprint_id)
      link_to _sprint.title, admin_sprint_path(dr.sprint_id)
    end
    column 'Dish' do |dr|
      _dish = Dish.find(dr.dish_id)
      link_to _dish.title, admin_dish_path(dr.dish_id)
    end
  end
end
