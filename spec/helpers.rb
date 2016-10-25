module Helpers
  # Helper method to parse a response
  #
  # @param [ActionController::TestResponse] response
  # @return [Hash]
  def parse_response(response)
    JSON.parse(response.body)
  end

  def auth_request(user)
    sign_in user
    request.headers.merge!(user.create_new_auth_token)
  end
end
