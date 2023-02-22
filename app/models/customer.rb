class Customer < ApplicationRecord
  include Bcrypt

  validates_presence_of :email
  validates_presence_of :password, on: :create
  validates :email, uniqueness: true, presence: true

  has_secure_password

  has_many :subscriptions
  has_many :teas, through: :subscriptions
end
