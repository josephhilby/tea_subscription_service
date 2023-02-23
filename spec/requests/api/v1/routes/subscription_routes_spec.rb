require 'rails_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :routing do
	describe 'routing' do
		let!(:tea) { create(:tea) }
		let!(:customer) { create(:customer) }
		let!(:subscription) { create(:subscription, tea: tea, customer: customer) }

		it 'routes to #index' do
			expect(get: "/api/v1/subscriptions?api_key=#{customer.api_key}").to route_to('api/v1/subscriptions#index', "api_key"=>"#{customer.api_key}")
		end

    it 'routes to #show' do
			expect(get: "/api/v1/subscriptions/#{subscription.id}?api_key=#{customer.api_key}").to route_to('api/v1/subscriptions#show', "id"=>"#{subscription.id}", "api_key"=>"#{customer.api_key}")
		end

		it 'routes to #create' do
			expect(post: "/api/v1/subscriptions?api_key=#{customer.api_key}", params: { body: 'params' }).to route_to('api/v1/subscriptions#create', "api_key"=>"#{customer.api_key}")
		end

		it 'routes to #update' do
			expect(patch: "/api/v1/subscriptions/#{subscription.id}?api_key=#{customer.api_key}", params: { body: 'params' }).to route_to('api/v1/subscriptions#update', "id"=>"#{subscription.id}", "api_key"=>"#{customer.api_key}")
		end

		it 'routes to #destroy' do
			expect(delete: "/api/v1/subscriptions/#{subscription.id}?api_key=#{customer.api_key}").to route_to('api/v1/subscriptions#destroy', "id"=>"#{subscription.id}", "api_key"=>"#{customer.api_key}")
		end
	end
end