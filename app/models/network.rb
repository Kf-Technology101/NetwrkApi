class Network < ApplicationRecord
  # has_and_belongs_to_many :users
  has_many :networks_users, dependent: :destroy
  has_many :users, through: :networks_users
  has_many :posts

  validates_uniqueness_of :post_code
end
