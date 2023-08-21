# frozen_string_literal: true

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.custom_payload do |controller|
    request = controller.request
    {
      current_user_id: controller.try(:current_user).try(:id),
      host: request.host,
      path: request.path,
      query_string: request.query_string,
      referer: request.referer,
      user_agent: request.user_agent
    }
  end
end
