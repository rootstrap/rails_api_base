require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
# require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative 'env_variables'

module App
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.secret_key_base = ENV['SECRET_KEY_BASE']

    config.autoload_paths += %W(#{config.root}/lib)

    ActionMailer::Base.smtp_settings = {
      address: 'smtp.sendgrid.net',
      port: 25,
      domain: 'www.api.com',
      authentication: :plain,
      user_name: ENV['SENGRID_USERNAME'],
      password: ENV['SENGRID_PASSWORD']
    }
    config.action_mailer.default_url_options = { host: ENV['SERVER_URL'] }
    config.action_mailer.default_options = {
      from: 'no-reply@api.com'
    }
  end
end
