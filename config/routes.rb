Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get '/subscriptions', to: 'subscription#index'
      post '/subscriptions', to: 'subscription#create'
      delete '/subscriptions/:id', to: 'subscription#destroy'
    end
  end
end
