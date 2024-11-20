# frozen_string_literal: true

Rails.application.configure do
  config.lograge.enabled = Rails.env.production?
  config.lograge.base_controller_class = ['ActionController::API', 'ActionController::Base']
  config.lograge.custom_payload do |controller|
    request = controller.request
    {
      current_user_id: controller.current_user&.id,
      host: request.host,
      path: request.path,
      query_string: request.query_string,
      referer: request.referer,
      user_agent: request.user_agent,
      remote_ip: request.remote_ip
    }
  end
end
