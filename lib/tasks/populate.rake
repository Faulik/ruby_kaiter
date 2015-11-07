require 'populator'
require 'faker'

namespace :populate do
  desc 'Create random categories'
  task categories: [:environment] do
    Category.populate(2..5) do |category|
      category.title = Faker::Lorem.word
    end
  end

  desc 'Create random meals'
  task meals: [:environment] do
    _categories = Category.all.pluck(:id)
    Meal.populate(40..50) do |meal|
      meal.title = Faker::Lorem.words(3).join(' ')
      meal.description = Faker::Lorem.sentence(5)
      meal.price = rand(100)
      meal.type = 'Meal'
      meal.category_id = _categories.sample 1
    end
  end

  desc 'Create random bussines dish'
  task bussines_dish: [:environment] do
    _number = 0
    _categories = Category.all.pluck(:id)
    _meals = Meal.all.pluck(:id, :price)
    BussinesDish.populate 7 do |bd|
      bd.title = Faker::Book.title
      bd.description = Faker::Lorem.sentence(5)
      bd.type = 'BussinesDish'
      bd.category_id = _categories.sample 1
      # Select 5 random
      _selected_meals = _meals.sample(rand(3..5))
      # Sum up their prices
      bd.price =  _selected_meals.reduce(0) { |m,i| m += i[1] }
      # Wrap their id's
      bd.children_ids = convert_to_pg_array _selected_meals.map { |i| i[0] }
    end
  end

  desc 'Create random sprints'
  task sprints: [:environment] do
    _number = 0
    Sprint.populate 4 do |sprint|
      sprint.state = 'pending'
      sprint.started_at = Date.commercial(2015, 44 + _number)
      # Add one week
      _number +=1
      sprint.finished_at = Date.commercial(2015, 44 + _number)
      sprint.title = "Sprint # #{_number}"
    end
    # Need to instantinate for some reason
    _temp = Sprint.first
    _temp.start
    _temp.save
  end

  desc 'Create random daily menus'
  task daily_menus: [:environment] do
    _number = 0
    _dishes = Dish.all.pluck(:id)
    DailyMenu.populate 7 do |dm|
      dm.day_number = _number
      dm.dish_ids = convert_to_pg_array _dishes.sample 20
      dm.max_total = 100..150
      _number +=1
    end
  end

  desc 'Create random persons'
  task persons: [:environment] do
    password = 'password'
    Person.populate(2..5) do |person|
      person.email = Faker::Internet.safe_email
      person.name = Faker::Name.name
      person.encrypted_password = Person.new(password: password).encrypted_password
      person.sign_in_count = 0
      person.failed_attempts = 0
      person.authentication_token = Faker::Internet.password(15)
    end
  end

  desc 'Create random daily rations'
  task :daily_rations => [:environment] do
    _people = Person.all.pluck(:id)
    _sprint = Sprint.first
    _daily_menu = DailyMenu.all
    _dishes = Dish.all.pluck(:id, :price)
    _people.each do |_person|
      _daily_menu.each do |dm|
        _dish_ids = dm.dish_ids.sample 3
        DailyRation.populate 3 do |dr|
          dr.quantity = 1..3
          dr.person_id = _person
          dr.daily_menu_id = dm.id
          dr.sprint_id = _sprint.id
          dr.dish_id = _dish_ids.pop
          dr.price = find_price(_dishes, dr.dish_id)
        end
      end
    end
  end

  desc 'Create categories, meals, bussines dishes, sprints, daily menus, persons'
  task :all => [:environment] do
    Rake::Task['populate:categories'].invoke
    p 'Categories done'
    Rake::Task['populate:meals'].invoke
    p 'Meals done'
    Rake::Task['populate:bussines_dish'].invoke
    p 'Bussines dishes done'
    Rake::Task['populate:sprints'].invoke
    p 'Sprints done'
    Rake::Task['populate:daily_menus'].invoke
    p 'Daily menus done'
    Rake::Task['populate:persons'].invoke
    p 'Persons done'
    Rake::Task['populate:daily_rations'].invoke
    p 'Daily rations done'
  end

  def convert_to_pg_array(array)
    array.to_s.tr('[', '{').tr(']', '}')
  end

  def find_price(array, id)
    array.detect { |i| i[0] == id }
  end
end
