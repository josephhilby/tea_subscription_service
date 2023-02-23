require 'rails_helper'

describe 'Index Subscriptions API' do
  let!(:customer_1) { create(:customer) }
  let!(:tea_1) { create(:tea) }
  let!(:tea_2) { create(:tea) }
  let!(:tea_3) { create(:tea) }

  let!(:customer_2) { create(:customer) }
  let!(:tea_4) { create(:tea) }

  let!(:customer_1_subscription) { create(:subscription, customer: customer_1, tea: tea_1) }
  let!(:customer_2_subscription) { create(:subscription, customer: customer_2, tea: tea_3) }

  context 'with valid params' do
    it 'can GET a list of subscriptions' do
      create(:subscription, customer: customer_1, tea: tea_2)
      create(:subscription, customer: customer_1, tea: tea_3)

      get api_v1_subscriptions_path, :params => { api_key: customer_1.api_key }

      expect(response).to be_successful
      expect(response.status).to eq(200)

      subscriptions_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscriptions_response).to be_an(Hash)
      expect(subscriptions_response.count).to eq(1)
      expect(subscriptions_response[:data]).to be_an(Array)

      expect(subscriptions_response[:data].count).to eq(3)
      expect(subscriptions_response[:data].first).to be_an(Hash)

      subscriptions_response[:data].each do |subscription|

        expect(subscription.count).to eq(4)
        expect(subscription).to have_key(:id)
        expect(subscription[:id]).to be_an(String)
        expect(subscription[:id]).to_not eq(customer_2_subscription.id)

        expect(subscription).to have_key(:type)
        expect(subscription[:type]).to be_an(String)

        expect(subscription).to have_key(:attributes)
        expect(subscription[:attributes]).to be_an(Hash)

        expect(subscription).to have_key(:relationships)
        expect(subscription[:relationships]).to be_an(Hash)

        expect(subscription[:attributes].count).to eq(4)
        expect(subscription[:attributes]).to have_key(:title)
        expect(subscription[:attributes][:title]).to be_an(String)

        expect(subscription[:attributes]).to have_key(:price)
        expect(subscription[:attributes][:price]).to be_an(String)

        expect(subscription[:attributes]).to have_key(:status)
        expect(subscription[:attributes][:status]).to be_an(String)

        expect(subscription[:attributes]).to have_key(:frequency)
        expect(subscription[:attributes][:frequency]).to be_an(String)

        expect(subscription[:relationships].count).to eq(2)
        expect(subscription[:relationships]).to have_key(:customer)
        expect(subscription[:relationships][:customer]).to be_an(Hash)

        expect(subscription[:relationships][:customer].count).to eq(1)
        expect(subscription[:relationships][:customer]).to have_key(:data)
        expect(subscription[:relationships][:customer][:data]).to be_an(Hash)

        expect(subscription[:relationships][:customer][:data].count).to eq(2)
        expect(subscription[:relationships][:customer][:data]).to have_key(:id)
        expect(subscription[:relationships][:customer][:data][:id]).to be_an(String)

        expect(subscription[:relationships][:customer][:data]).to have_key(:type)
        expect(subscription[:relationships][:customer][:data][:type]).to be_an(String)

        expect(subscription[:relationships]).to have_key(:tea)
        expect(subscription[:relationships][:tea]).to be_an(Hash)

        expect(subscription[:relationships][:tea].count).to eq(1)
        expect(subscription[:relationships][:tea]).to have_key(:data)
        expect(subscription[:relationships][:tea][:data]).to be_an(Hash)

        expect(subscription[:relationships][:tea][:data].count).to eq(2)
        expect(subscription[:relationships][:tea][:data]).to have_key(:id)
        expect(subscription[:relationships][:tea][:data][:id]).to be_an(String)

        expect(subscription[:relationships][:tea][:data]).to have_key(:type)
        expect(subscription[:relationships][:tea][:data][:type]).to be_an(String)
      end
	  end
  end

  context 'with no subscriptions' do
    it 'returns an error' do
      customer = create(:customer)

			get api_v1_subscriptions_path, :params => { api_key: customer.api_key }

			expect(response).not_to be_successful
			expect(response.status).to eq(404)

			subscriptions_response = JSON.parse(response.body, symbolize_names: true)

			expect(subscriptions_response).to have_key(:message)
			expect(subscriptions_response[:message]).to be_a(String)
			expect(subscriptions_response[:message]).to eq("Not Found")
		end
  end

  context 'with a non-valid key' do
    it 'returns an error' do
			get api_v1_subscriptions_path, :params => { api_key: 'bad key' }

			expect(response).not_to be_successful
			expect(response.status).to eq(401)

			subscriptions_response = JSON.parse(response.body, symbolize_names: true)

			expect(subscriptions_response).to have_key(:message)
			expect(subscriptions_response[:message]).to be_a(String)
			expect(subscriptions_response[:message]).to eq("Invalid api_key")
		end
  end

  context 'with no key' do
    it 'returns an error' do
			get api_v1_subscriptions_path

			expect(response).not_to be_successful
			expect(response.status).to eq(401)

			subscriptions_response = JSON.parse(response.body, symbolize_names: true)

			expect(subscriptions_response).to have_key(:message)
			expect(subscriptions_response[:message]).to be_a(String)
			expect(subscriptions_response[:message]).to eq("Invalid or missing api_key")
		end
  end
end