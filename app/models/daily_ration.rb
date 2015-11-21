# == Schema Information
#
# Table name: daily_rations
#
#  id            :integer          not null, primary key
#  price         :float
#  quantity      :integer
#  person_id     :integer
#  daily_menu_id :integer
#  sprint_id     :integer
#  dish_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class DailyRation < ActiveRecord::Base
  validates :price, presence: true
  validates :quantity, presence: true

  belongs_to :dish
  belongs_to :sprint
  belongs_to :daily_menu
  belongs_to :person

  def as_json(options = nil)
    super ({
      only: [
        :id, :price, :quantity,
        :person_id, :daily_menu_id, :sprint_id, :dish_id
      ]
    }).merge(options || {})
  end
end
