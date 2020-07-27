module MockMailer
  class UserMailer < ApplicationMailer
    def test_email; end
  end
end

describe ApplicationMailer do
  it 'job is created' do
    expect {
      MockMailer::UserMailer.test_email.deliver_later
    }.to have_enqueued_job.on_queue('mailers')
  end
end
