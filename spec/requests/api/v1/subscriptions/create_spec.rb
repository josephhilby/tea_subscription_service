require 'rails_helper'

describe "Create Subscriptions API" do
  let!(:customer) { create(:customer) }
  let!(:tea) { create(:tea) }
  let!(:subscription_params) { {
        title: 'title',
        price: 'price',
        status: 'status',
        frequency: 'frequency',
        customer_id: customer.id,
        tea_id: tea.id
      } }
  let!(:bad_params) { {
        title: 'title',
        price: 'price',
        customer_id: customer.id,
        tea_id: tea.id
      } }
  let!(:headers) { { "CONTENT_TYPE" => "application/json" } }

  context 'given valid params' do
    it "can POST a new subscription" do
      post api_v1_subscriptions_path, headers: headers, params: JSON.generate(api_key: customer.api_key, subscription: subscription_params)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      subscription_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscription_response).to have_key(:message)
      expect(subscription_response[:message]).to be_a(String)
      expect(subscription_response[:message]).to eq("Subscription added successfully")

      created_subscription = Subscription.last

      expect(created_subscription.title).to eq(subscription_params[:title])
      expect(created_subscription.price).to eq(subscription_params[:price])
      expect(created_subscription.status).to eq(subscription_params[:status])
      expect(created_subscription.frequency).to eq(subscription_params[:frequency])
      expect(created_subscription.customer_id).to eq(subscription_params[:customer_id])
      expect(created_subscription.tea_id).to eq(subscription_params[:tea_id])
    end
  end

  context 'given non-valid params' do
    it 'returns an error' do
      post api_v1_subscriptions_path, headers: headers, params: JSON.generate(api_key: customer.api_key, subscription: bad_params)

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      subscription_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscription_response).to have_key(:message)
      expect(subscription_response[:message]).to be_a(String)
      expect(subscription_response[:message]).to eq("Status can't be blank and Frequency can't be blank")
    end

    it 'returns an error' do
      post api_v1_subscriptions_path, headers: headers, params: JSON.generate(api_key: customer.api_key, subscription: "wrong data type")

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      subscription_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscription_response).to have_key(:message)
      expect(subscription_response[:message]).to be_a(String)
      expect(subscription_response[:message]).to eq("Check request body formatting")
    end

    it 'returns an error' do
      post api_v1_subscriptions_path, headers: headers, params: JSON.generate(api_key: customer.api_key)

      expect(response).not_to be_successful
      expect(response.status).to eq(400)

      subscription_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscription_response).to have_key(:message)
      expect(subscription_response[:message]).to be_a(String)
      expect(subscription_response[:message]).to eq("Check request body formatting")
    end
  end

  context 'given a non-valid key' do
    it 'returns an error' do
      post api_v1_subscriptions_path, headers: headers, params: JSON.generate(api_key: 'bad_key', subscription: subscription_params)

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
      post api_v1_subscriptions_path, headers: headers, params: JSON.generate(subscription: subscription_params)

      expect(response).not_to be_successful
      expect(response.status).to eq(401)

      subscription_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscription_response).to have_key(:message)
      expect(subscription_response[:message]).to be_a(String)
      expect(subscription_response[:message]).to eq("Invalid or missing api_key")
    end
  end
end