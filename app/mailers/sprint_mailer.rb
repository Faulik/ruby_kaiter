# Sending mail to all users about new sprint
class SprintMailer < ApplicationMailer
  default from: 'notifications@caiter.ua',
          to: proc { Person.pluck(:email) }

  def sprint_email(sprint)
    @sprint = sprint

    users.each do |user|
      @user = user
      mail(subject: 'New sprint created!')
    end
  end

  def users
    Person.all
  end
end
