# frozen_string_literal: true

require 'rspec/openapi'

# Set request `headers` - generate parameters with headers for a request
RSpec::OpenAPI.request_headers = %w[access-token uid client]

# Set response `headers` - generate parameters with headers for a response
RSpec::OpenAPI.response_headers = %w[access-token expiry token-type uid client]

RSpec::OpenAPI.path = ->(arg) { "doc/openapi#{ENV['TEST_ENV_NUMBER']}.yaml" }
