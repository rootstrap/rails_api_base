module Helpers
  # Helper method to parse a response
  #
  # @return [Hash]
  def json
    JSON.parse(response.body).with_indifferent_access
  end

  def auth_headers
    @auth_headers ||= user.create_new_auth_token
  end

  def uid_header
    auth_headers['uid']
  end

  def access_token_header
    auth_headers['access-token']
  end

  def client_header
    auth_headers['client']
  end
end
