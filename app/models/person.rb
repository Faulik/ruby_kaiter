class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless Person.where(authentication_token: token).first
    end
  end
end
