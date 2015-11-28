FactoryGirl.define do
  factory :daily_menu do
    sequence(:day_number) { |n| n }
    max_total 150
    dish_ids [1,2,3].to_s.tr('[', '{').tr(']', '}')
  end
end