require 'rails_helper'

describe "Update Subscriptions API" do
  let!(:customer_1) { create(:customer) }
  let!(:customer_2) { create(:customer) }
  let!(:tea) { create(:tea) }
  let!(:subscription_1) { create(:subscription, customer: customer_1, tea: tea) }
  let!(:subscription_2) { create(:subscription, customer: customer_2, tea: tea) }
  let!(:subscription_params) { { title: "New Title" } }
  let!(:headers) { {"CONTENT_TYPE" => "application/json"} }

	context 'given a valid ID and Key' do
		it "can PATCH an existing subscription" do
      previous_title = subscription_1.title
			patch api_v1_subscription_path(subscription_1), headers: headers, params: JSON.generate({api_key: customer_1.api_key, subscription: subscription_params})

			expect(response).to be_successful
      expect(response.status).to eq(200)

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

			subscription_result = Subscription.find_by(id: subscription_1.id)

			expect(subscription_result.title).to_not eq(previous_title)
			expect(subscription_result.title).to eq("New Title")
		end
	end

	context 'given a non-valid ID' do
		it 'returns an error' do
			patch api_v1_subscription_path(subscription_2), headers: headers, params: JSON.generate({api_key: customer_1.api_key, subscription: subscription_params})

			expect(response).not_to be_successful
			expect(response.status).to eq(401)

			subscription_response = JSON.parse(response.body, symbolize_names: true)

			expect(subscription_response).to have_key(:message)
			expect(subscription_response[:message]).to be_a(String)
			expect(subscription_response[:message]).to eq("Invalid api_key")
		end

		it 'returns an error' do
			patch api_v1_subscription_path(Subscription.last.id + 1), headers: headers, params: JSON.generate({api_key: customer_1.api_key, subscription: subscription_params})

			expect(response).not_to be_successful
			expect(response.status).to eq(404)

			subscription_response = JSON.parse(response.body, symbolize_names: true)

			expect(subscription_response).to have_key(:message)
			expect(subscription_response[:message]).to be_a(String)
			expect(subscription_response[:message]).to eq("Not Found")
		end
	end

	context 'given a non-valid key' do
		it 'returns an error' do
			patch api_v1_subscription_path(subscription_1), headers: headers, params: JSON.generate({api_key: "bad key", subscription: subscription_params})

			expect(response).not_to be_successful
			expect(response.status).to eq(401)

			subscription_response = JSON.parse(response.body, symbolize_names: true)

			expect(subscription_response).to have_key(:message)
			expect(subscription_response[:message]).to be_a(String)
			expect(subscription_response[:message]).to eq("Invalid api_key")
		end
	end

	context 'given no key' do
		it 'returns an error' do
			patch api_v1_subscription_path(subscription_1), headers: headers, params: JSON.generate({subscription: subscription_params})

			expect(response).not_to be_successful
			expect(response.status).to eq(401)

			subscription_response = JSON.parse(response.body, symbolize_names: true)

			expect(subscription_response).to have_key(:message)
			expect(subscription_response[:message]).to be_a(String)
			expect(subscription_response[:message]).to eq("Invalid or missing api_key")
		end
	end
end