class TwitterFeed
  require 'twitter'

  def self.perform
    puts 'start'*100
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "iLR8G2qTqBEL0L2W4rV11xQdX"
      config.consumer_secret     = "4phuCBbYt2g0eSGZFsCqeGio48LDUmFk5uAcBSxkw54p0HnA12"
      config.access_token        = "355004746-1e0zikRiwfxrnJbxsZYoDALkpvo1PX501mv9d16v"
      config.access_token_secret = "mYW1Dbj8E0aJNkhaQ7UVWdFSfVna1c9crYznoTd8dfY3i"
    end
    # puts client.inspect
    feed = Twitter::REST::Client.user_timeline("olexandr93")
    puts feed
  end
end
