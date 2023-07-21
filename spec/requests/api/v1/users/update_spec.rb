# frozen_string_literal: true

describe 'PUT api/v1/user/' do
  subject(:endpoint) { put api_v1_user_path, params:, headers: auth_headers, as: :json }

  let(:user)             { create(:user) }
  let(:api_v1_user_path) { '/api/v1/user' }

  context 'with valid params' do
    let(:params) { { user: { username: 'new username' } } }

    it 'returns success' do
      endpoint
      expect(response).to have_http_status(:success)
    end

    it 'updates the user' do
      endpoint
      expect(user.reload.username).to eq(params[:user][:username])
    end

    it 'returns the user id' do
      endpoint
      expect(json[:user][:id]).to eq user.id
    end

    it 'returns the user full name' do
      endpoint
      expect(json[:user][:name]).to eq user.full_name
    end
  end

  context 'with invalid data' do
    let(:params) { { user: { email: 'notanemail' } } }

    it 'does not return success' do
      endpoint
      expect(response).not_to have_http_status(:success)
    end

    it 'does not update the user' do
      endpoint
      expect(user.reload.email).not_to eq(params[:email])
    end

    it 'returns the error' do
      endpoint
      expect(json[:errors][:email]).to include('is not an email')
    end
  end

  context 'with missing params' do
    let(:params) { {} }

    it 'returns the missing params error' do
      endpoint
      expect(json[:error]).to eq 'A required param is missing'
    end
  end
end
