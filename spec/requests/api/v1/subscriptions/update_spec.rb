require 'rails_helper'

describe "Update Subscriptions API" do
	context 'given a valid ID and Key' do
		it "can PATCH an existing subscription" do
      customer = create(:customer)
      tea = create(:tea)
			subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id)
			previous_title = Subscription.last.title
			subscription_params = { title: "New Title" }
			headers = {"CONTENT_TYPE" => "application/json"}

			patch api_v1_subscription_path(subscription), headers: headers, params: JSON.generate({api_key: customer.api_key, subscription: subscription_params})

			expect(response).to be_successful
      expect(response.status).to eq(200)

			subscription_result = Subscription.find_by(id: subscription.id)

			expect(subscription_result.title).to_not eq(previous_title)
			expect(subscription_result.title).to eq("New Title")
		end
	end

	context 'given a non-valid ID' do
		it 'returns an error' do
			customer_1 = create(:customer)
			customer_2 = create(:customer)
      tea = create(:tea)
			subscription_1 = create(:subscription, customer_id: customer_1.id, tea_id: tea.id)
			subscription_2 = create(:subscription, customer_id: customer_2.id, tea_id: tea.id)
      subscription_params = { title: "New Title" }
      headers = {"CONTENT_TYPE" => "application/json"}

			patch api_v1_subscription_path(subscription_2), headers: headers, params: JSON.generate({api_key: customer_1.api_key, subscription: subscription_params})

			expect(response).not_to be_successful
			expect(response.status).to eq(401)

			subscription_response = JSON.parse(response.body, symbolize_names: true)

			expect(subscription_response).to have_key(:message)
			expect(subscription_response[:message]).to be_a(String)
			expect(subscription_response[:message]).to eq("Invalid api_key")
		end

		it 'returns an error' do
			customer = create(:customer)
      tea = create(:tea)
			subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id)
      subscription_params = { title: "New Title" }
      headers = {"CONTENT_TYPE" => "application/json"}

			patch api_v1_subscription_path(Subscription.last.id + 1), headers: headers, params: JSON.generate({api_key: customer.api_key, subscription: subscription_params})

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
			customer = create(:customer)
      tea = create(:tea)
			subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id)
      subscription_params = { title: "New Title" }
      headers = {"CONTENT_TYPE" => "application/json"}

			patch api_v1_subscription_path(subscription.id), headers: headers, params: JSON.generate({api_key: "bad key", subscription: subscription_params})

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
			customer = create(:customer)
      tea = create(:tea)
			subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id)
      subscription_params = { title: "New Title" }
      headers = {"CONTENT_TYPE" => "application/json"}

			patch api_v1_subscription_path(subscription.id), headers: headers, params: JSON.generate({subscription: subscription_params})

			expect(response).not_to be_successful
			expect(response.status).to eq(401)

			subscription_response = JSON.parse(response.body, symbolize_names: true)

			expect(subscription_response).to have_key(:message)
			expect(subscription_response[:message]).to be_a(String)
			expect(subscription_response[:message]).to eq("Invalid or missing api_key")
		end
	end
end