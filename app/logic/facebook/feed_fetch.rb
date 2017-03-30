class FeedFetch
  require 'koala'

  def self.perform
    # @graph = Koala::Facebook::API.new(User.last.providers.where(name: 'facebook').first.token)
    access_token = User.last.providers.first.token
    @graph = Koala::Facebook::API.new(access_token)
    puts @graph.inspect
    # @posts = @graph.get_connection('me', 'posts',{ fields: ['id', 'message', 'link', 'name', 'description', "likes.summary(true)", "shares", "comments.summary(true)"]})
    # puts @posts.inspect
    @user = @graph.get_object("me")
    puts @user
    @feed = @graph.get_connection('LinkUpSt', 'posts', {
      limit: 20,
      fields: ['message', 'id', 'from', 'type', 'picture', 'link', 'created_time', 'updated_time']
    })
    # @feed = @graph.get_connection('me', 'feed')
    # @postid = @feed.first['id']
    # @post_data = @post_graph.get_connections(@postid, 'likes')
  end
end
