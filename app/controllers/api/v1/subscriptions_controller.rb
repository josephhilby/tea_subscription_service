module Api
	module V1
		class SubscriptionsController < ApplicationController
      before_action :customer_key
      # Had to add this because I forgot the --api tag on creation and now have CSRF protection.
      skip_before_action :verify_authenticity_token

			def create
        # Need to do a better job to check params (no params), validations are catching bad params.
        # Suggest check data layout prior to strong params (like in the index and show test).
        # This bug was caught with postman testing
        new_subscription = Subscription.new(subscription_params)
        customer_by_key = Customer.find_by(api_key: customer_key)
        if !customer_by_key
          render json: { message: 'Invalid api_key' }, status: 401
        elsif !new_subscription.save
          render json: { message: new_subscription.errors.full_messages.to_sentence }, status: 400
        elsif new_subscription.save && customer_by_key
          render json: { message: "Subscription added successfully" }, status: 201
        end
			end

			def destroy
        customer_by_key = Customer.find_by(api_key: customer_key)
        subscription = Subscription.find_by(id: params[:id])
				if !subscription
          render json: { message: 'Not Found' }, status: 404
        elsif !customer_by_key || subscription.customer_id != customer_by_key.id
          render json: { message: 'Invalid api_key' }, status: 401
        elsif subscription && customer_by_key
          Subscription.delete(params[:id])
					render json: { }, status: 204
        end
			end

			def index
        customer_by_key = Customer.find_by(api_key: customer_key)
        if !customer_by_key
          render json: { message: 'Invalid api_key' }, status: 401
        elsif customer_by_key.subscriptions.empty?
          render json: { message: 'Not Found' }, status: 404
        elsif customer_by_key && !customer_by_key.subscriptions.empty?
          render json: SubscriptionSerializer.new(customer_by_key.subscriptions)
        end
			end

      def show
        customer_by_key = Customer.find_by(api_key: customer_key)
        subscription = Subscription.find_by(id: params[:id])
        if !subscription
          render json: { message: 'Not Found' }, status: 404
        elsif !customer_by_key || subscription.customer_id != customer_by_key.id
          render json: { message: 'Invalid api_key' }, status: 401
        elsif subscription && customer_by_key
				  render json: SubscriptionSerializer.new(subscription)
        end
			end

      def update
        # Need to do a better job to check params (no params and bad params), validations are catching this for create. You don't have that with update.
        # Suggest check data layout prior to strong params (like in the index and show test).
        # This bug was caught with postman testing
        customer_by_key = Customer.find_by(api_key: customer_key)
				subscription = Subscription.find_by(id: params[:id])
        if !subscription
          render json: { message: 'Not Found' }, status: 404
        elsif !customer_by_key || subscription.customer_id != customer_by_key.id
          render json: { message: 'Invalid api_key' }, status: 401
        elsif subscription && customer_by_key
					render json: SubscriptionSerializer.new(Subscription.update(params[:id], subscription_params))
        end
			end

			private

			def subscription_params
				params.require(:subscription).permit(:title, :price, :status, :frequency, :customer_id, :tea_id)
			end

      def customer_key
        if params[:api_key]
          params[:api_key]
        else
          render json: { message: 'Invalid or missing api_key' }, status: 401
        end
      end
		end
	end
end