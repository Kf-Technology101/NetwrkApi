# Likes implementation
class UserLike < ApplicationRecord
  belongs_to :liked_messages, foreign_key: 'message_id', class_name: 'Message'
  belongs_to :liked_users, foreign_key: 'user_id', class_name: 'User'

  validates :user_id, uniqueness: { scope: :message_id }
end
