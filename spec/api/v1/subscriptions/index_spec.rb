require 'rails_helper'

describe 'Index Subscriptions API' do
	it 'can GET a list of subscriptions' do
    customer_1 = create(:customer)
    tea_1 = create(:tea)
    tea_2 = create(:tea)
    tea_3 = create(:tea)

    customer_2 = create(:customer)
    tea_4 = create(:tea)

		create(:subscription, customer: customer_1, tea: tea_1)
		create(:subscription, customer: customer_1, tea: tea_2)
		create(:subscription, customer: customer_1, tea: tea_3)
		customer_2_subscription = create(:subscription, customer: customer_2, tea: tea_3)

    subscription_params = { api_key: 'bad key' }
    headers = {"CONTENT_TYPE" => "application/json"}

		get api_v1_subscriptions_path, headers: headers, params: JSON.generate(subscription: subscription_params)
		expect(response).to be_successful

		subscriptions = JSON.parse(response.body, symbolize_names: true)

    expect(subscriptions).to be_an(Hash)
		expect(subscriptions.count).to eq(1)
    expect(subscriptions[:data]).to be_an(Array)

    expect(subscriptions[:data].count).to eq(3)
    expect(subscriptions[:data].first).to be_an(Hash)

		subscriptions[:data].each do |subscription|

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