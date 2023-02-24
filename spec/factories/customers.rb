# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    address { Faker::Address.full_address }
    password { 'password' }
    password_digest { 'password' }
    api_key { SecureRandom.urlsafe_base64 }
  end
end
