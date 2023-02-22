require 'rails_helper'

describe "Create Subscriptions API" do
  context 'given valid params' do
    it "can POST a new subscription" do
      customer = create(:customer)
      tea = create(:tea)
      subscription_params = ({
          api_key: customer.api_key,
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
  context 'given a non-valid params' do
    it 'returns an error' do
      customer_2 = create(:customer)
      tea_2 = create(:tea)
      subscription_params_2 = ({
          api_key: customer_2.api_key,
          title: 'title',
          price: 'price',
          customer_id: customer_2.id,
          tea_id: tea_2.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_subscriptions_path, headers: headers, params: JSON.generate(subscription: subscription_params_2)

      expect(response).not_to be_successful

      subscription = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)

      expect(subscription).to have_key(:message)
      expect(subscription[:message]).to be_a(String)
      expect(subscription[:message]).to eq("Status can't be blank and Frequency can't be blank")
    end
  end
  context 'given a non-valid key' do
    it 'returns an error' do
      customer_3 = create(:customer)
      tea_3 = create(:tea)
      subscription_params_3 = ({
          api_key: 'bad_key',
          title: 'title',
          price: 'price',
          status: 'status',
          frequency: 'frequency',
          customer_id: customer_3.id,
          tea_id: tea_3.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post api_v1_subscriptions_path, headers: headers, params: JSON.generate(subscription: subscription_params_3)

      expect(response).not_to be_successful

      subscription = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(401)

      expect(subscription).to have_key(:message)
      expect(subscription[:message]).to be_a(String)
      expect(subscription[:message]).to eq("Invalid api_key")
    end
  end
end