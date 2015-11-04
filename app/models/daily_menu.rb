# == Schema Information
#
# Table name: daily_menus
#
#  id         :integer          not null, primary key
#  day_number :integer
#  max_total  :float
#  dish_ids   :integer          default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DailyMenu < ActiveRecord::Base
  validates :day_number, presence: true
  validates :max_total, presence: true
end
