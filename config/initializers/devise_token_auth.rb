DeviseTokenAuth.setup do |config|
  config.default_confirm_success_url = '/'
  config.default_password_reset_url = ENV.fetch('PASSWORD_RESET_URL', nil)
  config.enable_standard_devise_support = true
  config.token_lifespan = 2.years
  config.batch_request_buffer_throttle = 10.seconds
  config.change_headers_on_each_request = false
  config.max_number_of_devices = 5
end
