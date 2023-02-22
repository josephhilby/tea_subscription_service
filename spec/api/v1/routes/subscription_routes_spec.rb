require 'rails_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :routing do
	describe 'routing' do
		let!(:tea) { create(:tea) }
		let!(:customer) { create(:customer) }
		let!(:subscription) { create(:subscription, tea: tea, customer: customer) }

		it 'routes to #index' do
			expect(get: '/api/v1/subscriptions').to route_to('api/v1/subscriptions#index')
		end

    it 'routes to #show' do
			expect(get: "/api/v1/subscriptions/#{subscription.id}").to route_to('api/v1/subscriptions#show', "id"=>"#{subscription.id}")
		end

		it 'routes to #create' do
			expect(post: '/api/v1/subscriptions', params: { body: 'params' }).to route_to('api/v1/subscriptions#create')
		end

		it 'routes to #update' do
			expect(patch: "/api/v1/subscriptions/#{subscription.id}", params: { body: 'params' }).to route_to('api/v1/subscriptions#update', "id"=>"#{subscription.id}")
		end

		it 'routes to #destroy' do
			expect(delete: "/api/v1/subscriptions/#{subscription.id}").to route_to('api/v1/subscriptions#destroy', "id"=>"#{subscription.id}")
		end
	end
end