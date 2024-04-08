# frozen_string_literal: true

module Impersonation
  class Verifier
    EXPIRATION = 5.minutes
    PURPOSE = :impersonation

    def sign!(data)
      message_verifier.generate(data, expires_in: EXPIRATION, purpose: PURPOSE)
    end

    def verify!(signed_data)
      message_verifier.verify(signed_data, purpose: PURPOSE)
    end

    private

    def message_verifier
      @message_verifier ||= ActiveSupport::MessageVerifier.new(
        Rails.application.secret_key_base,
        digest: 'SHA256', serializer: JSON, url_safe: true
      )
    end
  end
end
