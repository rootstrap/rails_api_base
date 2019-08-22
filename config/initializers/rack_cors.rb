module App
  class Application < Rails::Application
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
                 headers: :any,
                 methods: %i[get post options put delete],
                 expose: %w[access-token uid client]
      end
    end
  end
end
