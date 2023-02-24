# frozen_string_literal: true

class AddApiKeyToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :api_key, :string
  end
end
