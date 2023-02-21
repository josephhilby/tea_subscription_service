class CustomerSerializer
	include JSONAPI::Serializer

  set_type :customer
  set_id :id
  attributes :first_name, :last_name, :email, :address
end