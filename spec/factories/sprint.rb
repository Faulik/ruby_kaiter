FactoryGirl.define do
  factory :sprint do
    title 'Sprint title'
    started_at '2015-10-26'
    finished_at '2015-11-02'
    state 'pending'
  end
end