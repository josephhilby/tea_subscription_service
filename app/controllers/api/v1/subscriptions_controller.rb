module Api
	module V1
		class SubscriptionsController < ApplicationController
			before_action :check_params

			def create
				render json: SubscriptionsSerializer.new(Subscription.create(thing_params))
			end

			def destroy
				if Subscription.exists?(params[:id])
					render json: SubscriptionsSerializer.new(Subscription.delete(params[:id]))
				else
					render json: { errors: 'Not Found' }, status: 404
				end
			end

			def index
				render json: SubscriptionsSerializer.new(Subscription.all)
			end

			private

			def check_params
				return unless params[:name] == "" || !params[:name] || !params[:id]
				render json: { errors: 'Bad Request' }, status: 400
			end

			def thing_params
				params.require(:thing).permit(:name)
			end
		end
	end
end