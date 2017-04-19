class Message < ApplicationRecord
  belongs_to :network
  has_many :images
end
