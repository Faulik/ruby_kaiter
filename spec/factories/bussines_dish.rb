FactoryGirl.define do
  factory :bussines_dish do
    title 'Bussines dish title'
    description 'Bussines dish description'
    price 100
    type 'BussinesDish'
    children_ids [1,2,3].to_s.tr('[', '{').tr(']', '}')
  end
end