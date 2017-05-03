class Network < ApplicationRecord
  # has_and_belongs_to_many :users
  has_many :networks_users, dependent: :destroy
  has_many :users, through: :networks_users
  has_many :posts
  has_many :messages

  validates_uniqueness_of :post_code

  attr_accessor :current_user

  def accessed(user=nil)
    user ||= current_user
    NetworksUser.where(network_id: self.id,
                       user_id: user.id,
                       invitation_sent: true).first.present?
  end
end
