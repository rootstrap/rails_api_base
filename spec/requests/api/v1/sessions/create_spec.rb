require 'rails_helper'

describe 'POST api/v1/users/sign_in', type: :request do
  let(:password) { 'password' }
  let(:token) do
    {
      '70crCAAYmNP1xLkKKM09zA' =>
      {
        'token' => '$2a$10$mSeRnpVMaaegCpn3AhORGe5wajFhgMoBjGIrMwq4Qq2mP6f/OHu1y',
        'expiry' => 153_574_356_4
      }
    }
  end
  let(:user) { create(:user, password: password, tokens: token) }

  context 'with correct params' do
    before do
      params = {
        user:
          {
            email: user.email,
            password: password
          }
      }
      post new_user_session_path, params: params, as: :json
    end

    it 'returns success' do
      expect(response).to be_successful
    end

    it 'returns the user' do
      expect(json[:user][:id]).to eq(user.id)
      expect(json[:user][:email]).to eq(user.email)
      expect(json[:user][:username]).to eq(user.username)
      expect(json[:user][:uid]).to eq(user.uid)
      expect(json[:user][:provider]).to eq('email')
      expect(json[:user][:first_name]).to eq(user.first_name)
      expect(json[:user][:last_name]).to eq(user.last_name)
    end

    it 'returns a valid client and access token' do
      token = response.header['access-token']
      client = response.header['client']
      expect(user.reload.valid_token?(token, client)).to be_truthy
    end
  end

  context 'with incorrect params' do
    it 'return errors upon failure' do
      params = {
        user: {
          email: user.email,
          password: 'wrong_password!'
        }
      }
      post new_user_session_path, params: params, as: :json

      expect(response).to be_unauthorized
      expected_response = {
        error: 'Invalid login credentials. Please try again.'
      }.with_indifferent_access
      expect(json).to eq(expected_response)
    end
  end
end
