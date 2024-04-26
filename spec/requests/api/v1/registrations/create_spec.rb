# frozen_string_literal: true

describe 'POST api/v1/users/sign_up' do
  subject { post user_registration_path, params:, as: :json }

  let(:email) { 'email@example.com' }
  let(:password) { 'password' }
  let(:password_confirmation) { 'password' }
  let(:username) { 'username' }
  let(:first_name) { 'first name' }
  let(:last_name) { 'last name' }
  let(:params) do
    {
      user: {
        email:,
        password:,
        password_confirmation:,
        username:,
        first_name:,
        last_name:
      }
    }
  end

  context 'with correct params' do
    before do
      subject
    end

    it_behaves_like 'there must not be a Set-Cookie in Header'
    it_behaves_like 'does not check authenticity token'

    it 'returns success' do
      expect(response).to be_successful
    end

    it 'returns the user' do
      user = User.last
      expect(json[:user][:id]).to eq(user.id)
      expect(json[:user][:email]).to eq(user.email)
      expect(json[:user][:username]).to eq(user.username)
      expect(json[:user][:uid]).to eq(user.uid)
      expect(json[:user][:provider]).to eq('email')
      expect(json[:user][:first_name]).to eq(user.first_name)
      expect(json[:user][:last_name]).to eq(user.last_name)
    end

    it 'returns a valid client and access token' do
      user = User.last
      token = response.header['access-token']
      client = response.header['client']
      expect(user.reload).to be_valid_token(token, client)
    end
  end

  context 'with incorrect params' do
    let(:params) do
      {
        user: {
          email:,
          password:,
          password_confirmation: 'wrong_password!'
        }
      }
    end

    it 'returns to be a client error' do
      subject
      expect(response).to be_client_error
    end

    it 'return errors upon failure' do
      subject
      expect(json.to_s).to match("Password confirmation doesn't match Password") 
    end
  end
end
