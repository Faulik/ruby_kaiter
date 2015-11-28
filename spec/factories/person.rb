FactoryGirl.define do
  factory :person do
    sequence(:email) { |n| "email#{n}@dot.com" }
    sequence(:authentication_token) { |n| "tokeeeeeeen#{n}" }

    name 'Bob'
    password 'password'
    password_confirmation { 'password' }
    sign_in_count 0
    failed_attempts 0
  end
end
