class  Dish < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true

  belongs_to :category
end
