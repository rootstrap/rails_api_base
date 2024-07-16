# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 3.3.3'

gem 'rails', '~> 7.1.3'

# Gems
gem 'activeadmin', '~> 3.2'
gem 'active_storage_base64', '~> 3.0.0'
gem 'aws-sdk-s3', '~> 1.156', require: false
gem 'bootsnap', '~> 1.17'
gem 'delayed_job_active_record', '~> 4.1'
gem 'devise', '~> 4.9'
gem 'devise_token_auth', '~> 1.2', '>= 1.2.3'
gem 'draper', '~> 4.0', '>= 4.0.1'
gem 'flipper', '~> 1.3.0'
gem 'flipper-active_record', '~> 1.3.0'
gem 'flipper-ui', '~> 1.3.0'
gem 'jbuilder', '~> 2.12'
gem 'jsbundling-rails', '~> 1.3'
gem 'lograge', '~> 0.14'
gem 'newrelic_rpm', '~> 9.11'
gem 'oj', '~> 3.16'
gem 'pagy', '~> 8.6'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'pundit', '~> 2.3'
gem 'rack-cors', '~> 2.0'
gem 'rswag-api', '~> 2.13.0'
gem 'rswag-ui', '~> 2.13.0'
gem 'sass-rails', '~> 6.0.0'
gem 'sendgrid', '~> 1.2.4'
gem 'sprockets', '~> 4.2.1'
gem 'strong_migrations', '~> 2.0'
gem 'yaaf', '~> 3.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

group :development, :test do
  gem 'annotate', '~> 3.2', '>= 3.0.3'
  gem 'dotenv-rails', '~> 3.1.2'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.4'
  gem 'pry-byebug', '~> 3.9', platform: :mri
  gem 'pry-rails', '~> 0.3.11'
  gem 'rspec-rails', '~> 6.1'
end

group :development do
  gem 'better_errors', '~> 2.10'
  gem 'binding_of_caller', '~> 1.0'
  gem 'brakeman', '~> 6.1'
  gem 'i18n-tasks', '~> 1.0.14'
  gem 'letter_opener', '~> 1.10'
  gem 'listen', '~> 3.9'
  gem 'rails_best_practices', '~> 1.20'
  gem 'reek', '~> 6.3'
  gem 'rubocop', '~> 1.65', require: false
  gem 'rubocop-capybara', '~> 2.21'
  gem 'rubocop-factory_bot', '~> 2.26', require: false
  gem 'rubocop-performance', '~> 1.21', require: false
  gem 'rubocop-rails', '~> 2.25', require: false
  gem 'rubocop-rake', '~> 0.6.0', require: false
  gem 'rubocop-rspec', '~> 3.0', require: false
  gem 'rubocop-rspec_rails', '~> 2.30.0', require: false
end

group :test do
  gem 'capybara', '~> 3.40'
  gem 'faraday-retry', '~> 2.2'
  gem 'knapsack', '~> 4.0'
  gem 'octokit', '~> 9.1'
  gem 'parallel_tests', '~> 4.7'
  gem 'pg_query', '~> 5.1.0'
  gem 'prosopite', '~> 1.4.2'
  gem 'rspec-openapi', '~> 0.18'
  gem 'rspec-retry', github: 'rootstrap/rspec-retry', branch: 'add-intermittent-callback'
  gem 'selenium-webdriver', '~> 4.22.0'
  gem 'shoulda-matchers', '~> 6.2'
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'webmock', '~> 3.23'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
