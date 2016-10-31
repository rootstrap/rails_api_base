class FacebookService
  def initialize(access_token)
    @access_token = access_token
  end

  def profile
    client.get_object('me?fields=email,first_name,last_name')
  end

  def client
    Koala::Facebook::API.new(@access_token, ENV['FACEBOOK_SECRET'])
  end
end
