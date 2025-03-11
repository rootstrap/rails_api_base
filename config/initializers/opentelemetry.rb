# frozen_string_literal: true

require 'opentelemetry/sdk'
require 'opentelemetry/instrumentation/all'

require 'opentelemetry-exporter-zipkin'
OpenTelemetry::SDK.configure do |c|
  c.service_name = 'rails_api_base'
  c.use_all() # enables all instrumentation!
end
