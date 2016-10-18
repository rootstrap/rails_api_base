# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'factory_girl_rails'

FactoryGirl.factories.clear
FactoryGirl.reload

Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = 'random'
  config.include FactoryGirl::Syntax::Methods

  config.before :each do |example_group|
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    ActionMailer::Base.deliveries.clear
  end

  config.after do
    DatabaseCleaner.clean
  end
end
