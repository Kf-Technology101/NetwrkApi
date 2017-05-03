class LegendaryLike < ApplicationRecord
  belongs_to :legendary_users, foreign_key: 'user_id', class_name: 'User'
  belongs_to :legendary_messages, foreign_key: 'message_id', class_name: 'Message'
  validates :user_id, uniqueness: { scope: :message_id }
end
