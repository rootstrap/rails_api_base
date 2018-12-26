require 'rails_helper'

describe 'POST api/v1/users/passwords', type: :request do
  let!(:user) { create(:user, password: 'mypass123') }

  context 'with valid params' do
    let(:params) { { email: user.email } }

    it 'returns a successful response' do
      post user_password_path, params: params, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'returns the user email' do
      post user_password_path, params: params, as: :json
      expect(json[:message]).to match(/#{user.email}/)
    end

    it 'sends an email' do
      expect { post user_password_path, params: params, as: :json }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  context 'with invalid params' do
    it 'does not return a successful response' do
      post user_password_path, params: { email: 'notvalid@example.com' }, as: :json
      expect(response.status).to eq(404)
    end

    it 'does not send an email' do
      expect {
        post user_password_path, params: { email: 'notvalid@example.com' }, as: :json
      }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end
  end
end
