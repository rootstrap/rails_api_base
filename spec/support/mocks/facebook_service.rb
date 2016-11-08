class FacebookService
  def initialize(access_token)
    @access_token = access_token
  end

  def profile
    if @access_token.present? && @access_token != 'invalid'
      {
        'first_name' => 'Test',
        'last_name' => 'test',
        'email' => @access_token == 'without_email' ? '' : 'test@facebook.com',
        'id' => '1234567890'
      }
    else
      fail Koala::Facebook::AuthenticationError.new 400, 'error'
    end
  end
end
