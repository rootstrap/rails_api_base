# frozen_string_literal: true

source 'https://rubygems.org'
ruby '~> 3.2.2'

gem 'rails', '~> 7.0.8'

gem 'activeadmin', '~> 3.2'
gem 'active_storage_base64', '~> 2.0.0'
gem 'aws-sdk-s3', '~> 1.141', require: false
gem 'bootsnap', '~> 1.17'
gem 'delayed_job_active_record', '~> 4.1'
gem 'devise', '~> 4.9'
gem 'devise_token_auth', '~> 1.2.2'
gem 'draper', '~> 4.0', '>= 4.0.1'
gem 'flipper', '~> 1.1.2'
gem 'flipper-active_record', '~> 1.1.1'
gem 'flipper-ui', '~> 1.1.1'
gem 'jbuilder', '~> 2.10'
gem 'jsbundling-rails', '~> 1.2', '>= 1.2.1'
gem 'lograge', '~> 0.14'
gem 'newrelic_rpm', '~> 9.6'
gem 'oj', '~> 3.16'
gem 'pagy', '~> 6.2'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'pundit', '~> 2.3'
gem 'rack-cors', '~> 2.0'
gem 'rswag-api', '~> 2.13.0'
gem 'rswag-ui', '~> 2.13.0'
gem 'sass-rails', '~> 6.0.0'
gem 'sendgrid', '~> 1.2.4'
gem 'sprockets', '~> 4.2.1'
gem 'strong_migrations', '~> 1.6'
gem 'yaaf', '~> 2.2'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

group :development, :test do
  gem 'annotate', '~> 3.2', '>= 3.0.3'
  gem 'dotenv-rails', '~> 2.8.1'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'pry-byebug', '~> 3.9', platform: :mri
  gem 'pry-rails', '~> 0.3.9'
end

group :development do
  gem 'better_errors', '~> 2.10'
  gem 'binding_of_caller', '~> 1.0'
  gem 'brakeman', '~> 6.1'
  gem 'i18n-tasks', '~> 1.0.13'
  gem 'letter_opener', '~> 1.7'
  gem 'listen', '~> 3.8'
  gem 'rails_best_practices', '~> 1.20'
  gem 'reek', '~> 6.2'
  gem 'rubocop', '~> 1.59', require: false
  gem 'rubocop-capybara', '~> 2.19'
  gem 'rubocop-factory_bot', '~> 2.24', require: false
  gem 'rubocop-performance', '~> 1.20', require: false
  gem 'rubocop-rails', '~> 2.23', require: false
  gem 'rubocop-rake', '~> 0.6.0', require: false
  gem 'rubocop-rspec', '~> 2.25', require: false
  gem 'spring', '~> 4.1'
end

group :test do
  gem 'capybara', '~> 3.39', '>= 3.39.2'
  gem 'faker', '~> 3.2'
  gem 'faraday-retry', '~> 2.2'
  gem 'knapsack', '~> 4.0'
  gem 'octokit', '~> 8.0'
  gem 'parallel_tests', '~> 4.4'
  gem 'pg_query', '~> 4.2.3'
  gem 'prosopite', '~> 1.4.2'
  gem 'rspec-openapi', '~> 0.10'
  gem 'rspec-rails', '~> 6.1'
  gem 'rspec-retry', github: 'rootstrap/rspec-retry', branch: 'add-intermittent-callback'
  gem 'selenium-webdriver', '4.16.0'
  gem 'shoulda-matchers', '~> 6.0'
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'webmock', '~> 3.19'
end

group :assets do
  gem 'uglifier', '~> 4.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
