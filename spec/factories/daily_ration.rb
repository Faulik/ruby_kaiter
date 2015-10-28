FactoryGirl.define do
  factory :daily_ration do
    price 100
    quantity 1
    
    association :person
    association :daily_menu
    association :sprint
    association :dish
  end
end