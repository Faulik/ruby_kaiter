class DailyRation < ActiveRecord::Base
  validates :price, presence: true
  validates :quantity, presence: true

  belongs_to :dish
  belongs_to :sprint
  belongs_to :daily_menu
  belongs_to :person
end
