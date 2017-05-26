class InstaFetch
  def self.perform(access_token)
    @insta = Instagram.configure do |config|
              config.client_id = "2d3db558942e4eaabfafc953263192a7"
              config.client_secret = "bcf35f1ba4e94d59ad9f2c6c1322c640"
              # config.access_token = access_token
            end
    client = Instagram.client(:access_token => access_token)
    client.user
    client.user_recent_media
    client.user_recent_media.each do |media|
      puts 'here is a caption'
      puts media.caption
      if media.caption.present?
        puts media.caption.text
      end
      puts 'here is a text'
      puts media.text
      puts 'here is an image'
      media.images.each do |image|
        puts 'here is an options'
        image.each do |o|
          unless o.class == String
            puts o.url
          end
        end
      end
    end
  end
end
