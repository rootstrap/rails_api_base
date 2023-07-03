# frozen_string_literal: true

if Rails.env.test?
  Rails.application.config.after_initialize do
    Prosopite.rails_logger = true
    Prosopite.raise = true
  end
end
