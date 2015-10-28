FactoryGirl.define do
  factory :daily_menu do
    day_number 1
    max_total 150
    dish_ids [1,2,3].to_s.tr('[', '{').tr(']', '}')
  end
end