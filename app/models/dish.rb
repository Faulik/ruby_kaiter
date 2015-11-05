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

class  Dish < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true

  has_many :daily_rations
  belongs_to :category
end
