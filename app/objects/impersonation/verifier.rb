# frozen_string_literal: true

module Impersonation
  class Verifier
    EXPIRATION = 5.minutes
    PURPOSE = :impersonation

    def sign!(data)
      signed_data = message_verifier.generate(data, expires_in: EXPIRATION, purpose: PURPOSE)
      Base64.urlsafe_encode64(signed_data)
    end

    def verify!(encoded_data)
      signed_data = Base64.urlsafe_decode64(encoded_data)
      message_verifier.verified(signed_data, purpose: PURPOSE)
    end

    private

    def message_verifier
      @message_verifier ||= ActiveSupport::MessageVerifier.new(
        Rails.application.secret_key_base,
        digest: 'SHA256', serializer: JSON
      )
    end
  end
end
