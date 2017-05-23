require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BKServer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths << "#{Rails.root}/app/logic/twilio"
    config.autoload_paths << "#{Rails.root}/app/logic/authentication"
    config.autoload_paths << "#{Rails.root}/app/logic/facebook"
    config.autoload_paths << "#{Rails.root}/app/logic/twitter"
    config.autoload_paths << "#{Rails.root}/app/logic/undercover"
    config.autoload_paths << "#{Rails.root}/app/logic/instagram"

    config.to_prepare do
      Devise::SessionsController.skip_before_action :check_token
    end
  end
end
