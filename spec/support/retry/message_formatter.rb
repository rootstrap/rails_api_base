# frozen_string_literal: true

module Retry
  class MessageFormatter
    attr_reader :example

    def initialize(example)
      @example = example
    end

    def to_s
      "\n*Intermittent test found:*" \
        "\n> Scenario: _#{description}_" \
        "\n> File: #{error_location}" \
        "\n> Seed: #{RSpec.configuration.seed}" \
        "\n> Error: ```#{error}```\n"
    end

    private

    def description
      example.metadata[:full_description]
    end

    def error
      example.execution_result.exception.to_s.split("\nDiff").first.presence ||
        example.metadata[:retry_exceptions].first
    end

    def error_location
      example.metadata[:location]
    end
  end
end
