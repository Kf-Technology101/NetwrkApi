class HomeController < ApplicationController
  skip_before_filter :check_token

  def index
  end

  def privacy
  end
end
