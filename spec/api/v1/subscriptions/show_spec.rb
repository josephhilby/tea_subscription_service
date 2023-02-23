require 'rails_helper'

describe 'Show Subscriptions API' do
	context 'given a valid params' do
		it 'can GET one subscription by ID' do
			customer = create(:customer)
      tea = create(:tea)
			subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id)
      subscription_params = { api_key: customer.api_key }
      headers = {"CONTENT_TYPE" => "application/json"}

      # why wont JSON.generate(subscription: subscription_params) work here like it will on every other spec file (only fails with get requests)?
			get api_v1_subscription_path(subscription), headers: headers, :params => { :subscription => subscription_params }

			expect(response).to be_successful

			subscription_response = JSON.parse(response.body, symbolize_names: true)

		  expect(subscription_response).to be_an(Hash)
      expect(subscription_response.count).to eq(1)
      expect(subscription_response[:data]).to be_an(Hash)

      expect(subscription_response[:data].count).to eq(4)
      expect(subscription_response[:data]).to have_key(:id)
      expect(subscription_response[:data][:id]).to be_an(String)

      expect(subscription_response[:data]).to have_key(:type)
      expect(subscription_response[:data][:type]).to be_an(String)

      expect(subscription_response[:data]).to have_key(:attributes)
      expect(subscription_response[:data][:attributes]).to be_an(Hash)

      expect(subscription_response[:data]).to have_key(:relationships)
      expect(subscription_response[:data][:relationships]).to be_an(Hash)

      expect(subscription_response[:data][:attributes].count).to eq(4)
      expect(subscription_response[:data][:attributes]).to have_key(:title)
      expect(subscription_response[:data][:attributes][:title]).to be_an(String)

      expect(subscription_response[:data][:attributes]).to have_key(:price)
      expect(subscription_response[:data][:attributes][:price]).to be_an(String)

      expect(subscription_response[:data][:attributes]).to have_key(:status)
      expect(subscription_response[:data][:attributes][:status]).to be_an(String)

      expect(subscription_response[:data][:attributes]).to have_key(:frequency)
      expect(subscription_response[:data][:attributes][:frequency]).to be_an(String)

      expect(subscription_response[:data][:relationships].count).to eq(2)
      expect(subscription_response[:data][:relationships]).to have_key(:customer)
      expect(subscription_response[:data][:relationships][:customer]).to be_an(Hash)

      expect(subscription_response[:data][:relationships][:customer].count).to eq(1)
      expect(subscription_response[:data][:relationships][:customer]).to have_key(:data)
      expect(subscription_response[:data][:relationships][:customer][:data]).to be_an(Hash)

      expect(subscription_response[:data][:relationships][:customer][:data].count).to eq(2)
      expect(subscription_response[:data][:relationships][:customer][:data]).to have_key(:id)
      expect(subscription_response[:data][:relationships][:customer][:data][:id]).to be_an(String)

      expect(subscription_response[:data][:relationships][:customer][:data]).to have_key(:type)
      expect(subscription_response[:data][:relationships][:customer][:data][:type]).to be_an(String)

      expect(subscription_response[:data][:relationships]).to have_key(:tea)
      expect(subscription_response[:data][:relationships][:tea]).to be_an(Hash)

      expect(subscription_response[:data][:relationships][:tea].count).to eq(1)
      expect(subscription_response[:data][:relationships][:tea]).to have_key(:data)
      expect(subscription_response[:data][:relationships][:tea][:data]).to be_an(Hash)

      expect(subscription_response[:data][:relationships][:tea][:data].count).to eq(2)
      expect(subscription_response[:data][:relationships][:tea][:data]).to have_key(:id)
      expect(subscription_response[:data][:relationships][:tea][:data][:id]).to be_an(String)

      expect(subscription_response[:data][:relationships][:tea][:data]).to have_key(:type)
      expect(subscription_response[:data][:relationships][:tea][:data][:type]).to be_an(String)
    end
	end

	context 'given a non-valid ID' do
		it 'returns an error' do
      customer = create(:customer)
      tea = create(:tea)
			subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id)
      subscription_params = { api_key: customer.api_key }
      headers = {"CONTENT_TYPE" => "application/json"}

			get api_v1_subscription_path(Subscription.last.id + 1), headers: headers, :params => { :subscription => subscription_params }

			expect(response).not_to be_successful

			thing = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(404)

			expect(thing).to have_key(:message)
			expect(thing[:message]).to be_a(String)
		end
	end

	context 'given a non-valid key' do
		it 'returns an error' do
      customer = create(:customer)
      tea = create(:tea)
			subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id)
      subscription_params = { api_key: 'bad key' }
      headers = {"CONTENT_TYPE" => "application/json"}

			get api_v1_subscription_path(subscription), headers: headers, :params => { :subscription => subscription_params }

			expect(response).not_to be_successful

			thing = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(401)

			expect(thing).to have_key(:message)
			expect(thing[:message]).to be_a(String)
		end
	end
end