# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/core'
require 'spec_helper'
require 'rspec/rails'
require 'simplecov'

SimpleCov.start

ActiveRecord::Migration.maintain_test_schema!
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
