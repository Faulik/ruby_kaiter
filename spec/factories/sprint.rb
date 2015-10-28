FactoryGirl.define do
  factory :sprint do
    title 'Sprint title'
    started_at Date.new(2015,10,27)
    finished_at Date.new(2015,11,2)
    state 'pending'
  end
end