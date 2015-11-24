# == Schema Information
#
# Table name: people
#
#  id                     :integer          not null, primary key
#  name                   :string           not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  authentication_token   :string
#  failed_attempts        :integer          default(0), not null
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :database_authenticatable, :token_authentication

  scope :with_rations_for, ->(id) { includes(:daily_rations).where(daily_rations: { sprint_id: id }) }
  scope :without_rations_for, ->(id) { includes(:daily_rations).where.not(daily_rations: { sprint_id: id }) }

  has_many :daily_rations

  def self.generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless Person.where(authentication_token: token).first
    end
  end

  def set_new_token
    this.authentication_token = Person.generate_authentication_token
    this.save
  end

  def destroy_token
    this.authentication_token = nil
    this.save
  end
end
