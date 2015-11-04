# == Schema Information
#
# Table name: dishes
#
#  id           :integer          not null, primary key
#  title        :string(45)
#  sort_order   :integer
#  description  :text
#  price        :float
#  type         :text
#  children_ids :integer          default([]), is an Array
#  category_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class BussinesDish < Dish
  validates :children_ids, presence: true
end
