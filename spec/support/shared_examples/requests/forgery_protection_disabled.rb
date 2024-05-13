# frozen_string_literal: true

RSpec.shared_examples 'does not check authenticity token' do
  context 'with forgery protection enabled' do
    around do |example|
      ActionController::Base.allow_forgery_protection = true
      example.run
      ActionController::Base.allow_forgery_protection = false
    end

    it 'does not fail' do
      subject
      expect(response).not_to be_client_error
    end
  end
end
