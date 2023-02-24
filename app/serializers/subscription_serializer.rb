# frozen_string_literal: true

class SubscriptionSerializer
  include JSONAPI::Serializer

  set_type :subscription
  set_id :id
  attributes :title, :price, :status, :frequency
  belongs_to :customer, record_type: :customer
  belongs_to :tea, record_type: :tea
end
