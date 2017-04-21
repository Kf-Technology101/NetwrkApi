# Likes implementation
class UserLike < ApplicationRecord
  validates :user_id, uniqueness: { scope: :message_id }
end
