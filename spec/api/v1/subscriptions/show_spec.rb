require 'rails_helper'

describe 'Show Subscriptions API' do
	context 'given a valid ID' do
		it 'can GET one subscription by ID' do
			customer = create(:customer)
      tea = create(:tea)
			id = create(:subscription, customer_id: customer.id, tea_id: tea.id).id

			get api_v1_subscription_path(id)

			expect(response).to be_successful

			subscription = JSON.parse(response.body, symbolize_names: true)
      # require'pry';binding.pry
		  expect(subscription).to be_an(Hash)
      expect(subscription.count).to eq(1)
      expect(subscription[:data]).to be_an(Hash)

      expect(subscription[:data].count).to eq(4)
      expect(subscription[:data]).to have_key(:id)
      expect(subscription[:data][:id]).to be_an(String)

      expect(subscription[:data]).to have_key(:type)
      expect(subscription[:data][:type]).to be_an(String)

      expect(subscription[:data]).to have_key(:attributes)
      expect(subscription[:data][:attributes]).to be_an(Hash)

      expect(subscription[:data]).to have_key(:relationships)
      expect(subscription[:data][:relationships]).to be_an(Hash)

      expect(subscription[:data][:attributes].count).to eq(4)
      expect(subscription[:data][:attributes]).to have_key(:title)
      expect(subscription[:data][:attributes][:title]).to be_an(String)

      expect(subscription[:data][:attributes]).to have_key(:price)
      expect(subscription[:data][:attributes][:price]).to be_an(String)

      expect(subscription[:data][:attributes]).to have_key(:status)
      expect(subscription[:data][:attributes][:status]).to be_an(String)

      expect(subscription[:data][:attributes]).to have_key(:frequency)
      expect(subscription[:data][:attributes][:frequency]).to be_an(String)

      expect(subscription[:data][:relationships].count).to eq(2)
      expect(subscription[:data][:relationships]).to have_key(:customer)
      expect(subscription[:data][:relationships][:customer]).to be_an(Hash)

      expect(subscription[:data][:relationships][:customer].count).to eq(1)
      expect(subscription[:data][:relationships][:customer]).to have_key(:data)
      expect(subscription[:data][:relationships][:customer][:data]).to be_an(Hash)

      expect(subscription[:data][:relationships][:customer][:data].count).to eq(2)
      expect(subscription[:data][:relationships][:customer][:data]).to have_key(:id)
      expect(subscription[:data][:relationships][:customer][:data][:id]).to be_an(String)

      expect(subscription[:data][:relationships][:customer][:data]).to have_key(:type)
      expect(subscription[:data][:relationships][:customer][:data][:type]).to be_an(String)

      expect(subscription[:data][:relationships]).to have_key(:tea)
      expect(subscription[:data][:relationships][:tea]).to be_an(Hash)

      expect(subscription[:data][:relationships][:tea].count).to eq(1)
      expect(subscription[:data][:relationships][:tea]).to have_key(:data)
      expect(subscription[:data][:relationships][:tea][:data]).to be_an(Hash)

      expect(subscription[:data][:relationships][:tea][:data].count).to eq(2)
      expect(subscription[:data][:relationships][:tea][:data]).to have_key(:id)
      expect(subscription[:data][:relationships][:tea][:data][:id]).to be_an(String)

      expect(subscription[:data][:relationships][:tea][:data]).to have_key(:type)
      expect(subscription[:data][:relationships][:tea][:data][:type]).to be_an(String)
    end
	end

	context 'given a non-valid ID' do
		it 'returns an error' do
			customer = create(:customer)
      tea = create(:tea)
			create(:subscription, customer_id: customer.id, tea_id: tea.id).id

			get api_v1_subscription_path(Subscription.last.id + 1)

			expect(response).not_to be_successful

			thing = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(404)

			expect(thing).to have_key(:message)
			expect(thing[:message]).to be_a(String)
		end
	end
end