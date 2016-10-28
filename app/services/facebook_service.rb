class FacebookService < SocialNetworkService
  def profile
    client.get_object('me?fields=email,first_name,last_name')
  end

  def client
    Koala::Facebook::API.new(@oauth_token, ENV['FACEBOOK_SECRET'])
  end
end
