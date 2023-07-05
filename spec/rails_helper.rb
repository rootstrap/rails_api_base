# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'

SimpleCov.start 'rails' do
  add_group 'Forms', 'app/forms'
  add_group 'Policies', 'app/policies'
  add_group 'Presenters', 'app/presenters'
  add_filter 'app/admin'
  add_filter 'config'
  add_filter 'spec'
end

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/core'
require 'spec_helper'
require 'rspec/rails'
require 'rspec/openapi'

ActiveRecord::Migration.maintain_test_schema!
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.render_views = true
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ActiveJob::TestHelper
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  # Form objects specs
  config.define_derived_metadata(file_path: Regexp.new('/spec/forms/')) do |metadata|
    metadata[:type] = :form
  end

  config.include Shoulda::Matchers::ActiveModel, type: :form
  config.include Shoulda::Matchers::ActiveRecord, type: :form

  # Detects N+1 queries
  config.before { Prosopite.scan }
  config.after { Prosopite.finish }
end

# API doc
# https://github.com/exoego/rspec-openapi#configuration
RSpec::OpenAPI.path = 'api-docs/openapi.yaml'
RSpec::OpenAPI.info = {
  description: 'Sample Project API',
  license: {
    'name': 'Apache 2.0',
    'url': 'https://www.apache.org/licenses/LICENSE-2.0.html'
  }
}
RSpec::OpenAPI.description_builder = -> (example) { example.full_description }

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
