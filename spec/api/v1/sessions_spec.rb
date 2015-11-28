require 'rails_helper'

RSpec.describe API::Version1::Engine do
  let!(:user) { FactoryGirl.create(:person) }

  context 'POST /sessions' do    
    it 'should return auth information' do
      post "/api/v1/sessions", { auth: { email: user.email, password: 'password' } }

      expect(response.status).to create_resource

      expect(response.body).to have_node(:auth).with(true)
      expect(response.body).to have_node(:email).with(user.email)
      expect(response.body).to have_node(:name).with(user.name)
    end

    it 'should update user token' do
      post "/api/v1/sessions", { auth: { email: user.email, password: 'password' } }

      expect(response.status).to create_resource

      expect(response.body).to have_node(:token).with(Person.find(user.id).authentication_token)
    end

    it 'should return error fo wrong email' do
      post "/api/v1/sessions", { auth: { email: 'wrong@dot.com', password: 'password' } }

      expect(response.status).to eq 422

      expect(response.body).to have_node(:error).with('Invalid login credentials')
    end

    it 'should return error fo wrong password' do
      post "/api/v1/sessions", { auth: { email: user.email, password: 'wrong' } }

      expect(response.status).to eq 422

      expect(response.body).to have_node(:error).with('Invalid login credentials')
    end
  end

  context 'GET /sessions' do
    it 'should return auth information' do
      get "/api/v1/sessions", {}, 'HTTP_X_AUTH_TOKEN' => user.authentication_token

      expect(response.status).to be_ok

      expect(response.body).to have_node(:auth).with(true)
      expect(response.body).to have_node(:email).with(user.email)
      expect(response.body).to have_node(:name).with(user.name)
      expect(response.body).to have_node(:token).with(user.authentication_token)
    end

    it 'should return error on wrong token' do
      get "/api/v1/sessions", {}, 'HTTP_X_AUTH_TOKEN' => 'wrong_token'

      expect(response.status).to eq 422

      expect(response.body).to have_node(:errors).with(['Invalid login credentials'])
    end
  end

  context 'DELETE /sessions' do
    it 'should delete user token' do
      delete "/api/v1/sessions", {}, 'HTTP_X_AUTH_TOKEN' => user.authentication_token

      expect(response.status).to be_ok

      expect(response.body).to have_node(:result).with('Success!')
      expect(Person.find(user.id).authentication_token).to eq nil
    end

    it 'should return error on wrong token' do
      get "/api/v1/sessions", {}, 'HTTP_X_AUTH_TOKEN' => 'wrong_token'

      expect(response.status).to eq 422

      expect(response.body).to have_node(:errors).with(['Invalid login credentials'])
    end
  end
end