# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :subscription do
    title { Faker::Subscription.plan }
    price { Faker::Commerce.price(range: 1..10.0, as_string: true) }
    status { Faker::Subscription.status }
    frequency { Faker::Subscription.subscription_term }
    customer { nil }
    tea { nil }
  end
end
