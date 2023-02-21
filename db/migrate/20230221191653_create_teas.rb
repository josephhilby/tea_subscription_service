class CreateTeas < ActiveRecord::Migration[6.1]
  def change
    create_table :teas do |t|
      t.string :title
      t.string :description
      t.string :temperature
      t.string :brew_time

      t.timestamps
    end
  end
end