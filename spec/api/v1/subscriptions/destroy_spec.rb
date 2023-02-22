require 'rails_helper'

describe "Destroy Subscriptions API" do
	context 'given valid params' do
		it "can DELETE a subscription" do
      customer = create(:customer)
      tea = create(:tea)
			subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id)
      subscription_params = { api_key: customer.api_key }
      headers = {"CONTENT_TYPE" => "application/json"}

			expect{ delete api_v1_subscription_path(subscription), headers: headers, params: JSON.generate(subscription: subscription_params) }.to change(Subscription, :count).by(-1)
			expect{Subscription.find(subscription.id)}.to raise_error(ActiveRecord::RecordNotFound)

			expect(response).to be_successful
      expect(response.status).to eq(204)

			expect(response.message).to be_a(String)
		end
	end

	context 'given a non-valid ID' do
		it 'returns an error' do
			customer = create(:customer)
      tea = create(:tea)
			subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id)
      subscription_params = { api_key: customer.api_key }
      headers = {"CONTENT_TYPE" => "application/json"}

			delete api_v1_subscription_path(Subscription.last.id + 1), headers: headers, params: JSON.generate(subscription: subscription_params)

			expect(response).not_to be_successful

			subscription = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(404)

			expect(subscription).to have_key(:message)
			expect(subscription[:message]).to be_a(String)
		end
	end

	context 'given a non-valid key' do
		it 'returns an error' do
			customer = create(:customer)
      tea = create(:tea)
			subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id)
      subscription_params = { api_key: 'bad key' }
      headers = {"CONTENT_TYPE" => "application/json"}

			delete api_v1_subscription_path(subscription.id), headers: headers, params: JSON.generate(subscription: subscription_params)

			expect(response).not_to be_successful

			subscription = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(401)

			expect(subscription).to have_key(:message)
			expect(subscription[:message]).to be_a(String)
		end
	end
end