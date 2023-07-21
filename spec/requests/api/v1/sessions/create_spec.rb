# frozen_string_literal: true

describe 'POST api/v1/users/sign_in' do
  subject(:endpoint) { post new_user_session_path, params:, as: :json }

  let(:password) { 'password' }
  let(:user) { create(:user, password:) }
  let(:params) do
    {
      user:
        {
          email: user.email,
          password:
        }
    }
  end

  context 'with correct params' do
    before do
      endpoint
    end

    it_behaves_like 'there must not be a Set-Cookie in Header'
    it_behaves_like 'does not check authenticity token'

    it 'returns success' do
      expect(response).to be_successful
    end

    it 'returns the user id' do
      expect(json[:user][:id]).to eq(user.id)
    end

    it 'returns the user email' do
      expect(json[:user][:email]).to eq(user.email)
    end

    it 'returns the user username' do
      expect(json[:user][:username]).to eq(user.username)
    end

    it 'returns the user uid' do
      expect(json[:user][:uid]).to eq(user.uid)
    end

    it 'returns the user provider' do
      expect(json[:user][:provider]).to eq('email')
    end

    it 'returns the user first name' do
      expect(json[:user][:first_name]).to eq(user.first_name)
    end

    it 'returns the user last name' do
      expect(json[:user][:last_name]).to eq(user.last_name)
    end

    it 'returns a valid client and access token' do
      token = response.header['access-token']
      client = response.header['client']
      expect(user.reload).to be_valid_token(token, client)
    end
  end

  context 'with incorrect params' do
    let(:params) do
      {
        user: {
          email: user.email,
          password: 'wrong_password!'
        }
      }
    end

    it 'returns to be unauthorized' do
      endpoint
      expect(response).to be_unauthorized
    end

    it 'return errors upon failure' do
      endpoint
      expected_response = {
        error: 'Invalid login credentials. Please try again.'
      }.with_indifferent_access
      expect(json).to eq(expected_response)
    end
  end
end
