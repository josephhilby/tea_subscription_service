# frozen_string_literal: true

class TeaSerializer
  include JSONAPI::Serializer

  set_type :tea
  set_id :id
  attributes :title, :description, :temperature, :brew_time
end
