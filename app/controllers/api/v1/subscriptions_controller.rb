module Api
	module V1
		class SubscriptionsController < ApplicationController
			# before_action :check_params, only: [:create]

			def create
				render json: SubscriptionSerializer.new(Subscription.create(subscription_params))
			end

			def destroy
				if Subscription.exists?(params[:id])
          Subscription.delete(params[:id])
					render json: { }, status: 204
				else
					render json: { errors: 'Not Found' }, status: 404
				end
			end

			def index
				render json: SubscriptionSerializer.new(Subscription.all)
			end

			private

			def check_params
				return unless params[:name] == "" || !params[:name] || !params[:id]
				render json: { errors: 'Bad Request' }, status: 400
			end

			def subscription_params
				params.require(:subscription).permit(:title, :price, :status, :frequency, :customer_id, :tea_id)
			end
		end
	end
end