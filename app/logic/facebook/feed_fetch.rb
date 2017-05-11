class FeedFetch
  require 'koala'

  def self.perform
    User.all.each do |user|
      access_token = user.providers.first.token
      feed = get_feed(access_token)
      feed.each do |message|
        save_message(message)
      end
    end
  end

  def self.get_feed(access_token)
    @graph = Koala::Facebook::API.new(access_token)
    @feed = @graph.get_connection('me', 'posts', {fields: ['id',
                                                           'message',
                                                           'full_picture',
                                                           'created_time']})
  end

  def self.save_message(message)
    
  end
end
