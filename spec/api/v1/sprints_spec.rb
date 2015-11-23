require 'rails_helper'

RSpec.describe API::Version1::Engine do
  let(:user) { FactoryGirl.create(:person) }

  context 'GET /sprints' do
    let!(:first_sprint) { FactoryGirl.create(:sprint, title: 'First', state: 'started') }
    let!(:second_sprint) { FactoryGirl.create(:sprint, title: 'Second', state: 'pending') }

    let!(:status) { get '/api/v1/sprints', {}, 'HTTP_X_AUTH_TOKEN' => user.authentication_token }

    it 'should return 200' do
      expect(status).to eq 200
    end

    it 'should have two nodes of sprints' do
      expect(JSON.parse(response.body).length).to eq 2
    end

    it 'should have first sprint attributes' do
      expect(response.body).to have_node(:title).with(first_sprint.title)
      expect(response.body).to have_node(:state).with(first_sprint.state)
      expect(response.body).to have_node(:started_at).with(first_sprint.started_at)
      expect(response.body).to have_node(:finished_at).with(first_sprint.finished_at)
    end

    it 'should have second sprint attributes' do
      expect(response.body).to have_node(:title).with(second_sprint.title)
      expect(response.body).to have_node(:state).with(second_sprint.state)
      expect(response.body).to have_node(:started_at).with(second_sprint.started_at)
      expect(response.body).to have_node(:finished_at).with(second_sprint.finished_at)
    end
  end

  context 'GET /sprints/#id/rations' do
    let!(:sprint) { FactoryGirl.create(:sprint) }
    let!(:daily_rations) { create_list(:daily_ration, 4, sprint_id: sprint.id, person_id: user.id) }

    it 'should return correct ration' do
      get "/api/v1/sprints/#{sprint.id}/rations", {}, 'HTTP_X_AUTH_TOKEN' => user.authentication_token

      expect(response.status).to eq 200

      expect(JSON.parse(response.body).length).to eq 4
    end
  end
end
