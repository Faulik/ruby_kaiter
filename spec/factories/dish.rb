FactoryGirl.define do
  factory :dish do
    title 'Dish title'
    description 'Dish description'
    price 100
    association :category
  end
end