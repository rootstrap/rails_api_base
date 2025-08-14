# frozen_string_literal: true

source 'https://rubygems.org'

ruby file: '.ruby-version'

gem 'rails', '~> 8.0.2'

# Gems
gem 'activeadmin', '~> 3.3'
gem 'active_storage_base64', '~> 3.0.0'
gem 'aws-sdk-s3', '~> 1.196', require: false
gem 'bootsnap', '~> 1.18'
gem 'cssbundling-rails', '~> 1.4'
gem 'devise', '~> 4.9'
gem 'devise_token_auth', github: 'lynndylanhurley/devise_token_auth'
gem 'draper', '~> 4.0'
gem 'flipper', '~> 1.3.5'
gem 'flipper-active_record', '~> 1.3.5'
gem 'flipper-ui', '~> 1.3.5'
gem 'good_job', '~> 4.11.1'
gem 'jbuilder', '~> 2.14'
gem 'jsbundling-rails', '~> 1.3'
gem 'lograge', '~> 0.14'
gem 'newrelic_rpm', '~> 9.19'
gem 'pagy', '~> 9.3'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.6'
gem 'pundit', '~> 2.5'
gem 'rack-cors', '~> 3.0'
gem 'rswag-api', '~> 2.16.0'
gem 'rswag-ui', '~> 2.16.0'
gem 'sendgrid', '~> 1.2.4'
gem 'sprockets-rails', '~> 3.5', '>= 3.5.2'
gem 'strong_migrations', '~> 2.4'
gem 'yaaf', '~> 3.0'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

group :development, :test do
  gem 'annotaterb', '~> 4.17.0'
  gem 'dotenv-rails', '~> 3.1.8'
  gem 'factory_bot_rails', '~> 6.5'
  gem 'faker', '~> 3.5'
  gem 'pry-byebug', '~> 3.11', platform: :mri
  gem 'pry-rails', '~> 0.3.11'
  gem 'rspec-rails', '~> 8.0'
end

group :development do
  gem 'better_errors', '~> 2.10'
  gem 'binding_of_caller', '~> 1.0'
  gem 'brakeman', '~> 7.1'
  gem 'i18n-tasks', '~> 1.0.15'
  gem 'letter_opener', '~> 1.10'
  gem 'listen', '~> 3.9'
  gem 'rails_best_practices', '~> 1.20'
  gem 'reek', '~> 6.5'
  gem 'rubocop', '~> 1.78', require: false
  gem 'rubocop-capybara', '~> 2.22'
  gem 'rubocop-factory_bot', '~> 2.27', require: false
  gem 'rubocop-performance', '~> 1.25', require: false
  gem 'rubocop-rails', '~> 2.32', require: false
  gem 'rubocop-rake', '~> 0.7.1', require: false
  gem 'rubocop-rspec', '~> 3.6', require: false
  gem 'rubocop-rspec_rails', '~> 2.31.0', require: false
end

group :test do
  gem 'capybara', '~> 3.40'
  gem 'faraday-retry', '~> 2.3'
  gem 'knapsack', '~> 4.0'
  gem 'octokit', '~> 10.0'
  gem 'parallel_tests', '~> 5.4'
  gem 'pg_query', '~> 6.1.0'
  gem 'prosopite', '~> 2.1.1'
  gem 'rspec-openapi', '~> 0.19'
  gem 'rspec-retry', github: 'rootstrap/rspec-retry', branch: 'add-intermittent-callback'
  gem 'selenium-webdriver', '~> 4.34.0'
  gem 'shoulda-matchers', '~> 6.5'
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'webmock', '~> 3.25'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
