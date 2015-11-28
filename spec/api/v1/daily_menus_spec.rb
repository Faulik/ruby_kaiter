require 'rails_helper'

RSpec.describe API::Version1::Engine do
  let!(:user) { FactoryGirl.create(:person) }

  context 'GET /daily_menus' do
    let!(:dishes) { create_list(:dish, 3) }
    let!(:menus) { create_list(:daily_menu, 7) }

    it 'should return auth information' do
      get "/api/v1/daily_menus", {}, 'HTTP_X_AUTH_TOKEN' => user.authentication_token

      expect(response.status).to be_ok

      menus.each do |menu|
        expect(response.body).to have_node(:id).with(menu.id)
        expect(response.body).to have_node(:dish_ids).with(menu.dish_ids)
        expect(response.body).to have_node(:day_number).with(menu.day_number)
      end

      dishes.each do |dish|
        expect(response.body).to have_node(:title).with(dish.title)
        expect(response.body).to have_node(:price).with(dish.price)
        expect(response.body).to have_node(:type).with(dish.type)
      end
    end
  end
end