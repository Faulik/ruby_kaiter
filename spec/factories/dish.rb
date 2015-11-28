FactoryGirl.define do
  factory :dish do
    title 'Dish title'
    description 'Dish description'
    price 20
    association :category
  end
end