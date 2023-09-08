# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@example.com'
  layout 'mailer'
end
