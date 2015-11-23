require 'rails_helper'

RSpec.describe SprintMailer, type: :mailer do
  context 'Generate New Sprint email' do
    let!(:user) { FactoryGirl.create(:person) }
    let!(:sprint) { FactoryGirl.create(:sprint) }
    let!(:email) { SprintMailer.sprint_email(sprint) }

    it 'should be in deliveries' do
      expect { email.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'should have correct \'from\'' do
      expect(email.from).to include 'notifications@caiter.ua'
    end

    it 'should have correct subject' do
      expect(email.subject).to eq 'New sprint created!'
    end
  end
end
