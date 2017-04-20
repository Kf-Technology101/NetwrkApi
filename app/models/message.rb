class Message < ApplicationRecord
  belongs_to :network
  has_many :images

  def image_urls
    urls = []
    images.each do |image|
      urls << image.image.url
    end
    urls
  end
end
