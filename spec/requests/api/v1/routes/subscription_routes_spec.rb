# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :routing do
  describe 'routing' do
    let!(:tea) { create(:tea) }
    let!(:customer) { create(:customer) }
    let!(:subscription) { create(:subscription, tea: tea, customer: customer) }

    it 'routes to #index' do
      expect(get: "/api/v1/subscriptions?api_key=#{customer.api_key}").to route_to('api/v1/subscriptions#index',
                                                                                   'api_key' => customer.api_key.to_s)
    end

    it 'routes to #show' do
      expect(get: "/api/v1/subscriptions/#{subscription.id}?api_key=#{customer.api_key}").to route_to(
        'api/v1/subscriptions#show', 'id' => subscription.id.to_s, 'api_key' => customer.api_key.to_s
      )
    end

    it 'routes to #create' do
      expect(post: "/api/v1/subscriptions?api_key=#{customer.api_key}").to route_to('api/v1/subscriptions#create',
                                                                                    'api_key' => customer.api_key.to_s)
    end

    it 'routes to #update' do
      expect(patch: "/api/v1/subscriptions/#{subscription.id}?api_key=#{customer.api_key}").to route_to(
        'api/v1/subscriptions#update', 'id' => subscription.id.to_s, 'api_key' => customer.api_key.to_s
      )
    end

    it 'routes to #destroy' do
      expect(delete: "/api/v1/subscriptions/#{subscription.id}?api_key=#{customer.api_key}").to route_to(
        'api/v1/subscriptions#destroy', 'id' => subscription.id.to_s, 'api_key' => customer.api_key.to_s
      )
    end
  end
end
