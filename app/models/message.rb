class Message < ApplicationRecord
  belongs_to :network
  has_many :images
  has_many :user_likes

  has_many :deleted_messages
  has_many :users, through: :deleted_messages

  attr_accessor :current_user

  def image_urls
    urls = []
    images.each do |image|
      urls << image.image.url
    end
    urls
  end

  def deleted_by_user?(user=nil)
    user ||= current_user
    users.include?(user)
  end
end
