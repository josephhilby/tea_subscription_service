# frozen_string_literal: true

require 'rails_helper'

describe 'Destroy Subscriptions API' do
  let!(:customer_1) { create(:customer) }
  let!(:customer_2) { create(:customer) }
  let!(:tea) { create(:tea) }
  let!(:subscription_1) { create(:subscription, customer: customer_1, tea: tea) }
  let!(:subscription_2) { create(:subscription, customer: customer_2, tea: tea) }

  context 'given valid params' do
    it 'can DELETE a subscription' do
      expect do
        delete api_v1_subscription_path(subscription_1),
               params: { api_key: customer_1.api_key }
      end.to change(Subscription, :count).by(-1)
      expect { Subscription.find(subscription_1.id) }.to raise_error(ActiveRecord::RecordNotFound)

      expect(response).to be_successful
      expect(response.status).to eq(204)

      expect { Subscription.find(subscription_1.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'given a non-valid ID' do
    it 'returns an error' do
      delete api_v1_subscription_path(Subscription.last.id + 1), params: { api_key: customer_1.api_key }

      expect(response).not_to be_successful
      expect(response.status).to eq(404)

      subscription_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscription_response).to have_key(:message)
      expect(subscription_response[:message]).to be_a(String)
      expect(subscription_response[:message]).to eq('Not Found')
    end

    it 'returns an error' do
      delete api_v1_subscription_path(subscription_2), params: { api_key: customer_1.api_key }

      expect(response).not_to be_successful
      expect(response.status).to eq(401)

      subscription_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscription_response).to have_key(:message)
      expect(subscription_response[:message]).to be_a(String)
      expect(subscription_response[:message]).to eq('Invalid api_key')
    end
  end

  context 'given a non-valid key' do
    it 'returns an error' do
      delete api_v1_subscription_path(subscription_1), params: { api_key: 'bad key' }

      expect(response).not_to be_successful
      expect(response.status).to eq(401)

      subscription_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscription_response).to have_key(:message)
      expect(subscription_response[:message]).to be_a(String)
      expect(subscription_response[:message]).to eq('Invalid api_key')
    end
  end

  context 'given no key' do
    it 'returns an error' do
      delete api_v1_subscription_path(subscription_1)

      expect(response).not_to be_successful
      expect(response.status).to eq(401)

      subscription_response = JSON.parse(response.body, symbolize_names: true)

      expect(subscription_response).to have_key(:message)
      expect(subscription_response[:message]).to be_a(String)
      expect(subscription_response[:message]).to eq('Invalid or missing api_key')
    end
  end
end
