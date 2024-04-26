# frozen_string_literal: true

describe 'PUT api/v1/user/' do
  subject { put api_v1_user_path, params:, headers: auth_headers, as: :json }

  let(:user)             { create(:user) }
  let(:api_v1_user_path) { '/api/v1/user' }

  before { subject }

  context 'with valid params' do
    let(:params) { { user: { username: 'new username' } } }

    it 'returns success' do
      expect(response).to have_http_status(:success)
    end

    it 'updates the user' do
      expect(user.reload.username).to eq(params[:user][:username])
    end

    it 'returns the user id' do
      expect(json[:user][:id]).to eq user.id
    end

    it 'returns the user full name' do
      expect(json[:user][:name]).to eq user.reload.full_name
    end
  end

  context 'with invalid data' do
    let(:params) { { user: { email: 'notanemail' } } }

    it 'does not return success' do
      expect(response).not_to have_http_status(:success)
    end

    it 'does not update the user' do
      expect(user.reload.email).not_to eq(params[:email])
    end

    it 'returns the error' do
      expect(json.dig(:errors, 0, :email)).to include('is not an email')
    end
  end

  context 'with missing params' do
    let(:params) { {} }

    it 'returns the missing params error' do
      expect(json.dig(:errors, 0, :message)).to eq 'A required param is missing'
    end
  end
end
