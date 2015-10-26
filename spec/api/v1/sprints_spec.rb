require 'spec_helper'

describe API::Version1::Engine do
  describe API::Version1::Engine do
    context 'GET /api/v1/sprints' do
      it 'should return correct items' do
        first_sprint = FactoryGirl.create(:sprint, title: 'First', status: 'started')
        second_sprint = FactoryGirl.create(:sprint, title: 'Second', status: 'pending')
        get '/api/v1/sprints'
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq [first_sprint, second_sprint]
      end
    end
  end
end