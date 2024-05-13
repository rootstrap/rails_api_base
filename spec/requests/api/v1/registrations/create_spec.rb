# frozen_string_literal: true

describe 'POST api/v1/users/sign_up' do
  subject { post user_registration_path, params:, as: :json }

  let(:params) do
    {
      user: {
        email: 'email@example.com',
        password: 'password',
        password_confirmation: 'password',
        username: 'username',
        first_name: 'first name',
        last_name: 'last name'
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
      expect(json[:user][:email]).to eq(params.dig(:user, :email))
      expect(json[:user][:username]).to eq(params.dig(:user, :username))
      expect(json[:user][:uid]).to eq(user.uid)
      expect(json[:user][:provider]).to eq('email')
      expect(json[:user][:first_name]).to eq(params.dig(:user, :first_name))
      expect(json[:user][:last_name]).to eq(params.dig(:user, :last_name))
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
          email: 'email@example.com',
          password: 'password',
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
