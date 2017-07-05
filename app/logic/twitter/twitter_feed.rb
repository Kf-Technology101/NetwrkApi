class TwitterFeed
  require 'twitter'

  def self.perform(user_id)#(token, secret)
    puts 'start'*100
    user = User.find_by(id: user_id)
    provider = user.providers.where(name: 'twitter').last
    if provider.present?
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "iLR8G2qTqBEL0L2W4rV11xQdX"
        config.consumer_secret     = "4phuCBbYt2g0eSGZFsCqeGio48LDUmFk5uAcBSxkw54p0HnA12"
        config.access_token        = provider.token#"760065835520159745-isrRmAW1O0s92J2GTmkKlCojASehsWk"
        config.access_token_secret = provider.secret#"TtxSuN1A7UnRJBWARFR6c9nEjcKoeiCYXYMrfTCKIPaEy"
      end
      puts 'USER ID'*100
      puts client.user.id
      puts client.inspect
      feed = client.home_timeline
      puts "TWITTER FEED " * 100
      puts feed.inspect
      feed.each do |f|
        puts 'TWEET ID'*100
        puts f.user.id
        puts "FEED SOURCE"*100
        puts f.url
        puts f.url.to_s
        link = f.url.to_s
        user.networks.each do |network|
          puts "TRUE OR FALSE"
          puts client.user.id == f.user.id
          if client.user.id == f.user.id
            old_message = Message.find_by(text: f.text,
                                          network_id: network.id,
                                          user_id: user_id,
                                          social: 'twitter',
                                          created_at: f.created_at.to_date,
                                          undercover: false,
                                          post_permalink: link)
            unless old_message.present?
              new_message = Message.create(text: f.text,
                                           network_id: network.id,
                                           user_id: user_id,
                                           social: 'twitter',
                                           created_at: f.created_at.to_date,
                                           undercover: false,
                                           post_permalink: link)
            end
          end
        end
      end
    end
  rescue
  end
end
