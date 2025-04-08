# frozen_string_literal: true

Rails.application.configure do
  # Don't depend on transactions
  config.good_job.enqueue_after_transaction_commit = true
  # Prioritize the queue high over the rest
  config.good_job.queues = 'high,*'
  # config.good_job.enable_cron = true
  # config.good_job.cron_graceful_restart_period = 5.minutes
  # config.good_job.cron = { example: { cron: '0 * * * *', class: 'ExampleJob'  } }
end
