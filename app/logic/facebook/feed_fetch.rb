class FeedFetch
  require 'koala'

  def self.perform
    # @graph = Koala::Facebook::API.new(User.last.providers.where(name: 'facebook').first.token)
    graph = Koala::Facebook::API.new(access_token)
    puts @graph.inspect
    # @posts = @graph.get_connection('me', 'posts',{ fields: ['id', 'message', 'link', 'name', 'description', "likes.summary(true)", "shares", "comments.summary(true)"]})
    # puts @posts.inspect
    @feed = @graph.get_connection('me', 'feed')
    puts @feed.inspect
    # @postid = @feed.first['id']
    # @post_data = @post_graph.get_connections(@postid, 'likes')
  end
end
