class NetworksUser < ApplicationRecord
  belongs_to :user
  belongs_to :network
  validates :network_id, uniqueness: { scope: :user_id }
end
