module Helpers
  # Helper method to parse a response
  #
  # @return [Hash]
  def parsed_response
    JSON.parse(response.body)
  end

  def auth_request(user)
    sign_in user
    request.headers.merge!(user.create_new_auth_token)
  end
end
