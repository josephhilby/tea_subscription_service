require 'rails_helper'

describe "Create Subscriptions API" do
	it "can POST a new subscription" do
    customer = create(:customer)
    tea = create(:tea)
		subscription_params = ({
		    title: 'title',
        price: 'price',
        status: 'status',
        frequency: 'frequency',
        customer_id: customer.id,
        tea_id: tea.id
		})
		headers = {"CONTENT_TYPE" => "application/json"}

		post api_v1_subscriptions_path, headers: headers, params: JSON.generate(subscription: subscription_params)

		created_subscription = Subscription.last

		expect(response).to be_successful
		expect(created_subscription.title).to eq(subscription_params[:title])
		expect(created_subscription.price).to eq(subscription_params[:price])
		expect(created_subscription.status).to eq(subscription_params[:status])
		expect(created_subscription.frequency).to eq(subscription_params[:frequency])
		expect(created_subscription.customer_id).to eq(subscription_params[:customer_id])
		expect(created_subscription.tea_id).to eq(subscription_params[:tea_id])
	end
end