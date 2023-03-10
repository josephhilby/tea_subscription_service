# frozen_string_literal: true

class AddPasswordToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :password_digest, :string
  end
end
