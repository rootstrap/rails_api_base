# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    ActionMailer::Base.smtp_settings = {
      address: 'smtp.sendgrid.net',
      authentication: :plain,
      domain: ENV.fetch('SERVER_HOST', nil),
      enable_starttls_auto: true,
      password: ENV.fetch('SENDGRID_API_KEY', nil),
      port: 587,
      user_name: 'apikey'
    }
    config.action_mailer.default_url_options = { host: ENV.fetch('SERVER_HOST', nil),
                                                 port: ENV.fetch('PORT', 3000) }
    config.action_mailer.default_options = {
      from: 'no-reply@example.com'
    }

    config.action_mailer.deliver_later_queue_name = 'mailers'

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    # Log N+1s using Rails strict_loading feature
    ENV['DISABLE_RAILS_STRICT_LOADING'] ||= 'true' if defined?(Rails::Console)
    config.active_record.strict_loading_by_default = ENV['DISABLE_RAILS_STRICT_LOADING'] != 'true'
    config.active_record.action_on_strict_loading_violation = :log
  end
end
