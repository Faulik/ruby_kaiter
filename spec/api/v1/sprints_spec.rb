require 'rails_helper'

RSpec.describe API::Version1::Engine do
  context 'GET /sprints' do
    let!(:first_sprint) { FactoryGirl.create(:sprint, title: 'First', state: 'started') }
    let!(:second_sprint) { FactoryGirl.create(:sprint, title: 'Second', state: 'pending') }

    it 'should return array correct items' do
      _sprints = [first_sprint.attributes, second_sprint.attributes]

      get '/api/v1/sprints'

      expect(response.status).to eq 200

      # Skipping date formating
      _sprints.zip(JSON.parse(response.body)).each do |actual, response|
        expect(response['id']).to eq actual['id']
        expect(response['state']).to eq actual['state']
        expect(Date.parse(response['started_at']).to_s).to eq actual['started_at'].to_s
        expect(Date.parse(response['finished_at']).to_s).to eq actual['finished_at'].to_s
      end
    end

    it 'should return item with correct' do
      get '/api/v1/sprints'

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)[0].keys).to eq first_sprint.attributes.keys
    end
  end

  context 'GET /sprints/#id/rations' do
    let!(:sprint) { FactoryGirl.create(:sprint) }
    let!(:daily_rations) { create_list(:daily_ration, 4, sprint_id: sprint.id) }

    it 'should return correct ration' do
      get "/api/v1/sprints/#{sprint.id}/rations"

      expect(response.status).to eq 200

      expect(JSON.parse(response.body).length).to eq 4
    end
  end
end
