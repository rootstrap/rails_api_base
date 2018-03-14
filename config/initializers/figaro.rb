# Put here the variables used by all the environments
variables = %w[SERVER_URL PASSWORD_RESET_URL]

unless Rails.env.test?
  # Variables not used by the test environment
  variables += %w[SECRET_KEY_BASE
                  SENDGRID_USERNAME
                  SENDGRID_PASSWORD
                  AWS_ACCESS_KEY_ID
                  AWS_SECRET_ACCESS_KEY
                  S3_BUCKET_NAME
                  AWS_BUCKET_REGION]
end

Figaro.require_keys(variables)
