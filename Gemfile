# frozen_string_literal: true

source 'https://rubygems.org'
ruby '~> 3.1.2'

gem 'rails', '~> 7.0.8'

gem 'activeadmin', '~> 2.9'
gem 'active_storage_base64', '~> 2.0.0'
gem 'arctic_admin', '~> 3.3.0'
gem 'aws-sdk-s3', '~> 1.134', require: false
gem 'bootsnap', '~> 1.16'
gem 'delayed_job_active_record', '~> 4.1', '>= 4.1.5'
gem 'devise', '~> 4.7', '>= 4.7.2'
gem 'devise_token_auth', '~> 1.2.2'
gem 'draper', '~> 4.0', '>= 4.0.1'
gem 'flipper', '~> 1.0.0'
gem 'flipper-active_record', '~> 1.0.0'
gem 'flipper-ui', '~> 1.0.0'
gem 'jbuilder', '~> 2.10'
gem 'lograge', '~> 0.13'
gem 'newrelic_rpm', '~> 9.4'
gem 'oj', '~> 3.16'
gem 'pagy', '~> 6.0'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.3'
gem 'pundit', '~> 2.3'
gem 'rack-cors', '~> 2.0'
gem 'sass-rails', '~> 6.0.0'
gem 'sendgrid', '~> 1.2.4'
gem 'sprockets', '~> 4.2.1'
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
  gem 'factory_bot_rails', '~> 6.2'
  gem 'knapsack', '~> 4.0'
  gem 'parallel_tests', '~> 4.2'
  gem 'pry-byebug', '~> 3.9', platform: :mri
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec_api_documentation', '~> 6.1.0'
  gem 'rspec-rails', '~> 6.0'
end

group :development do
  gem 'better_errors', '~> 2.10'
  gem 'binding_of_caller', '~> 1.0'
  gem 'brakeman', '~> 6.0'
  gem 'i18n-tasks', '~> 1.0.12'
  gem 'letter_opener', '~> 1.7'
  gem 'listen', '~> 3.8'
  gem 'rails_best_practices', '~> 1.20'
  gem 'reek', '~> 6.1', '>= 6.1.1'
  gem 'rubocop', '~> 1.55', require: false
  gem 'rubocop-factory_bot', '~> 2.23', '>= 2.23.1', require: false
  gem 'rubocop-performance', '~> 1.19', require: false
  gem 'rubocop-rails', '~> 2.20', '>= 2.20.2', require: false
  gem 'rubocop-rake', '~> 0.6.0', require: false
  gem 'rubocop-rspec', '~> 2.24', require: false
  gem 'spring', '~> 4.1'
end

group :test do
  gem 'faker', '~> 2.13'
  gem 'pg_query', '~> 4.2.3'
  gem 'prosopite', '~> 1.3.3'
  gem 'shoulda-matchers', '~> 5.3'
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'webmock', '~> 3.19'
end

group :assets do
  gem 'uglifier', '~> 4.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
