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
end
