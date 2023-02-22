module Api
	module V1
		class SubscriptionsController < ApplicationController
      before_action :customer_key

			def create
        new_subscription = Subscription.find_or_initialize_by(subscription_params)
        customer_by_id = Customer.find_by(id: subscription_params[:customer_id])
        customer_by_key = Customer.find_by(api_key: customer_key)
        if !(customer_by_id == customer_by_key)
          render json: { message: 'Invalid or missing api_key for customer id' }, status: 401
        elsif !new_subscription.save
          render json: { message: new_subscription.errors.full_messages.to_sentence }, status: 400
        elsif new_subscription.save && customer_by_id == customer_by_key
          render json: { message: "Subscription added successfully" }, status: 201
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

      def show
        subscription = Subscription.find_by(id: params[:id])
        if subscription
				  render json: SubscriptionSerializer.new(subscription)
        else
          render json: { message: 'Not Found' }, status: 404
        end
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

      def customer_key
        params.require(:subscription)[:api_key]
      end
		end
	end
end