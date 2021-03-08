require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.load_defaults 6.0

    config.add_autoload_paths_to_load_path = false

    ActionMailer::Base.smtp_settings = {
      address: 'smtp.sendgrid.net',
      authentication: :plain,
      domain: ENV['SERVER_HOST'],
      enable_starttls_auto: true,
      password: ENV['SENDGRID_API_KEY'],
      port: 587,
      user_name: 'apikey'
    }
    config.action_mailer.default_url_options = { host: ENV['SERVER_HOST'],
                                                 port: ENV.fetch('PORT', 3000) }
    config.action_mailer.default_options = {
      from: 'no-reply@api.com'
    }

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # ActiveAdmin needs the following middlewares to work properly.
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::MethodOverride
  end
end
