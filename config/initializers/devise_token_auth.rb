DeviseTokenAuth.setup do |config|
  config.default_confirm_success_url = '/'
  config.default_password_reset_url = ENV['PASSWORD_RESET_URL']
  config.enable_standard_devise_support = true
  config.token_lifespan = 1.year
  config.batch_request_buffer_throttle = 10.seconds
  config.change_headers_on_each_request = false
end
