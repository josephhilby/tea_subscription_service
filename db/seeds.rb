# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'factory_bot_rails'

customer_1 = FactoryBot.create(:customer)
customer_2 = FactoryBot.create(:customer)
customer_3 = FactoryBot.create(:customer)

tea_1 = FactoryBot.create(:tea)
tea_2 = FactoryBot.create(:tea)
tea_3 = FactoryBot.create(:tea)
tea_4 = FactoryBot.create(:tea)
tea_5 = FactoryBot.create(:tea)
tea_6 = FactoryBot.create(:tea)

FactoryBot.create(:subscription, customer_id: customer_1.id, tea_id: tea_1.id)
FactoryBot.create(:subscription, customer_id: customer_1.id, tea_id: tea_2.id)
FactoryBot.create(:subscription, customer_id: customer_1.id, tea_id: tea_3.id)

FactoryBot.create(:subscription, customer_id: customer_2.id, tea_id: tea_3.id)
FactoryBot.create(:subscription, customer_id: customer_2.id, tea_id: tea_4.id)
FactoryBot.create(:subscription, customer_id: customer_2.id, tea_id: tea_5.id)

