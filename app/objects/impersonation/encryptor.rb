# frozen_string_literal: true

module Impersonation
  class Encryptor
    EXPIRATION = 5.minutes
    PURPOSE = :impersonation

    def encrypt!(data)
      data.then {
        _1.to_json
      }.then {
        message_encryptor.encrypt_and_sign(_1, expires_in: EXPIRATION, purpose: PURPOSE)
      }.then {
        Base64.urlsafe_encode64(_1)
      }
    end

    def decrypt!(encrypted_data)
      encrypted_data.then {
        Base64.urlsafe_decode64(_1)
      }.then {
        message_encryptor.decrypt_and_verify(_1, purpose: PURPOSE)
      }.then {
        JSON.parse(_1)
      }
    end

    private

    def message_encryptor
      @message_encryptor ||= ActiveSupport::MessageEncryptor.new(
        Rails.application.secret_key_base[0, 32]
      )
    end
  end
end
