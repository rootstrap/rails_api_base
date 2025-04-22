# frozen_string_literal: true

module TelemetrySpan
  extend ActiveSupport::Concern

  included do
    helper_method :current_span
  end

  def current_span
    @current_span ||= OpenTelemetry::Trace.current_span
  end
end
