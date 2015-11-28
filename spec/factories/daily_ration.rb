FactoryGirl.define do
  factory :daily_ration do
    price 20
    quantity 1
    
    association :person
    association :daily_menu
    association :sprint
    association :dish

    trait :custom do
      transient do
        person
        daily_menu
        sprint
        dish
      end

      after(:create) do |ration, evaluator|
        ration.sprint = evaluator.sprint
        ration.person = evaluator.person
        ration.daily_menu = evaluator.daily_menu
        ration.dish = evaluator.dish
        ration.save
      end
    end
  end

end