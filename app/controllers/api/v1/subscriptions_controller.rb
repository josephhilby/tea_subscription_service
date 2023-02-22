module Api
	module V1
		class SubscriptionsController < ApplicationController

			def create
        new_subscription = Subscription.new(subscription_params)
        if new_subscription.save
          render json: { message: "Subscription added successfully" }, status: 201
        else
          render json: { message: new_subscription.errors.full_messages.to_sentence }, status: 400
        end
			end

			def destroy
				if Subscription.exists?(params[:id])
          Subscription.delete(params[:id])
					render json: { }, status: 204
				else
					render json: { message: 'Not Found' }, status: 404
				end
			end

			def index
				render json: SubscriptionSerializer.new(Subscription.all)
			end

      def update
				if Subscription.exists?(params[:id])
					render json: SubscriptionSerializer.new(Subscription.update(params[:id], subscription_params))
				else
					render json: { message: 'Not Found' }, status: 404
				end
			end

			private

			def subscription_params
				params.require(:subscription).permit(:title, :price, :status, :frequency, :customer_id, :tea_id)
			end
		end
	end
end