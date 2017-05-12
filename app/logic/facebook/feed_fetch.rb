class FeedFetch
  require 'koala'

  def self.perform
    User.all.each do |user|
      access_token = user.providers.last.token
      feed = get_feed(access_token)
      feed.each do |message|
        save_message(message)
      end
    end
  end

  def self.user_fetch(user_id)
    user = User.find_by(id: user_id)
    access_token = user.providers.last.token
    puts access_token
    feed = get_feed(access_token)
    puts feed.inspect
    feed.each do |message|
      puts message['created_time']
      save_message(message, user.id)
    end
  rescue
  end

  def self.get_feed(access_token)
    @graph = Koala::Facebook::API.new(access_token)
    @feed = @graph.get_connection('me', 'posts', {fields: ['id',
                                                           'message',
                                                           'full_picture',
                                                           'created_time']})
  end

  def self.save_message(message, user_id)
    user = User.find_by(id: user_id)
    puts 'created new_message'
    user.networks.each do |network|
      new_message = Message.find_or_create_by(text: message['message'],
                                              network_id: network.id,
                                              user_id: user_id,
                                              social: 'facebook',
                                              created_at: message['created_time'])
      # new_message.save
      if message['full_picture'].present?
        new_message.images << Image.create(image: URI.parse(message['full_picture']))
      end
      # new_message.created_at = message['created_time'].to_datetime
      # new_message.save
    end
  end
end
