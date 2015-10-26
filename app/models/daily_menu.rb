class DailyMenu < ActiveRecord::Base
  validates :day_number, presence: true
  validates :max_total, presence: true
end
