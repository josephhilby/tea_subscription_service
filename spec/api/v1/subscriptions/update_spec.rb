require 'rails_helper'

describe "Update Subscriptions API" do
	context 'given a valid ID' do
		it "can PATCH an existing subscription" do
      customer = create(:customer)
      tea = create(:tea)
			id = create(:subscription, customer_id: customer.id, tea_id: tea.id).id
			previous_title = Subscription.last.title
			subscription_params = { title: "New Title" }
			headers = {"CONTENT_TYPE" => "application/json"}

			patch api_v1_subscription_path(id), headers: headers, params: JSON.generate({subscription: subscription_params})
			subscription = Subscription.find_by(id: id)

			expect(response).to be_successful
			expect(subscription.title).to_not eq(previous_title)
			expect(subscription.title).to eq("New Title")
		end
	end

	context 'given a non-valid ID' do
		it 'returns an error' do
			customer = create(:customer)
      tea = create(:tea)
			create(:subscription, customer_id: customer.id, tea_id: tea.id)
			patch api_v1_subscription_path(Subscription.last.id + 1)

			expect(response).not_to be_successful

			subscription = JSON.parse(response.body, symbolize_names: true)

			expect(response.status).to eq(404)

			expect(subscription).to have_key(:message)
			expect(subscription[:message]).to be_a(String)
		end
	end
end