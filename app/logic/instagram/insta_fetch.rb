class InstaFetch
  def perform(access_token)
    @insta = Instagram.configure do |config|
              config.client_id = "2d3db558942e4eaabfafc953263192a7"
              config.client_secret = "bcf35f1ba4e94d59ad9f2c6c1322c640"
              config.access_token = access_token
            end
  end
end
