class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :database_authenticatable, :token_authentication

  def self.generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless Person.where(authentication_token: token).first
    end
  end
end
