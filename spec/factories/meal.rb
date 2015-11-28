FactoryGirl.define do
  factory :meal do
    title 'Meal title'
    description 'Meal description'
    price 20
    type 'Meal'
    association :category
  end
end