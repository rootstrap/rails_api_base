# frozen_string_literal: true

describe 'GET api/v1/users/:id/impersonate' do
  subject { get "/api/v1/users/#{user.id}/impersonate", params:, as: :json }

  let(:user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:expiry) { 1.hour.from_now }

  context 'with valid params' do
    let(:params) { { admin_user: admin_user.id, expiry: } }

    it 'returns the auth headers' do
      subject
      expect(response).to have_http_status(:no_content)
      expect(user.reload.tokens.flatten.last['impersonated_by']).to eq admin_user.id
      expect(Time.zone.at(user.reload.tokens.flatten.last['expiry'])).to be_between(expiry.utc - 5.minutes, expiry.utc)
      expect(response.headers).to include('client', 'token-type', 'access-token', 'Authorization', 'uid')
    end
  end

  context 'without admin_user' do
    let(:params) { { expiry: } }

    it 'returns error: could not find the record' do
      subject
      expect(response).to have_http_status(:not_found)
      expect(user.reload.tokens).to be_empty
      expect(response.headers).not_to include('client', 'token-type', 'access-token', 'Authorization', 'uid')
    end
  end

  context 'without expiry' do
    let(:params) { { admin_user: admin_user.id } }

    it 'returns error: a required param is missing' do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
      expect(user.reload.tokens).to be_empty
      expect(response.headers).not_to include('client', 'token-type', 'access-token', 'Authorization', 'uid')
    end
  end

  context 'when expiry is < Time.zone.now' do
    let(:expiry) { 1.hour.ago }
    let(:params) { { admin_user: admin_user.id, expiry: } }

    it 'returns error: your request is no longer valid' do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
      expect(user.reload.tokens).to be_empty
      expect(response.headers).not_to include('client', 'token-type', 'access-token', 'Authorization', 'uid')
    end
  end

  context 'when the user was impersonated by the same admin_user in a previous request' do
    let(:params) { { admin_user: admin_user.id, expiry: } }

    before do
      user.create_token(impersonated_by: admin_user.id)
      user.save!
    end

    it 'deletes old tokens from previous requests' do
      subject
      expect(user.reload.tokens.count).to eq 1
    end
  end

  context 'when the user has a token that is not associated with the admin_user' do
    let(:params) { { admin_user: admin_user.id, expiry: } }

    before do
      user.create_token
      user.save!
    end

    it 'keeps old tokens from previous requests' do
      subject
      expect(user.reload.tokens.count).to eq 2
    end
  end
end
