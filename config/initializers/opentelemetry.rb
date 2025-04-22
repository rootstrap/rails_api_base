# frozen_string_literal: true

require 'opentelemetry/sdk'

OpenTelemetry::SDK.configure do |c|
  c.service_name = 'rails_api_base'
  c.use_all # enables all instrumentation!
end
