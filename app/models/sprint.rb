# == Schema Information
#
# Table name: sprints
#
#  id          :integer          not null, primary key
#  title       :string(45)
#  started_at  :date
#  finished_at :date
#  state       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Sprint < ActiveRecord::Base
  include AASM
  validates :title, presence: true
  validates :state, presence: true

  has_many :daily_rations

  aasm column: 'state' do
    state :pending, initial: true
    state :started
    state :closed

    event :start do
      transitions from: :pending, to: :started
    end

    event :finish do
      transitions from: :started, to: :closed
    end
  end

  def as_json(options = nil)
    super ({
      only: [:id, :title, :started_at, :finished_at, :state]
      }).merge(options || {})
  end
end
