# frozen_string_literal: true

module DeviseTokenAuth
  module TokenFactory
    def self.create(client: nil, lifespan: nil, cost: nil)
      obj_client = 'abcdefghijklmnopqrstuv'
      obj_token = '123456789A123456789012'
      obj_token_hash = token_hash(obj_token, cost)
      obj_expiry = expiry(lifespan)

      Token.new(obj_client, obj_token, obj_token_hash, obj_expiry)
    end
  end
end
