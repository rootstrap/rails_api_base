# frozen_string_literal: true

module Impersonation
  class Verifier
    EXPIRATION = 5.minutes
    PURPOSE = :impersonation

    def sign!(data)
      data.then {
        message_verifier.generate(_1, expires_in: EXPIRATION, purpose: PURPOSE)
      }.then {
        Base64.urlsafe_encode64(_1)
      }
    end

    def verify!(signed_data)
      signed_data.then {
        Base64.urlsafe_decode64(_1)
      }.then {
        message_verifier.verified(_1, purpose: PURPOSE)
      }
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
