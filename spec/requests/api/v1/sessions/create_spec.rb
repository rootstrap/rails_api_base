describe 'POST api/v1/users/sign_in', type: :request do
  subject { post new_user_session_path, params: params }

  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:params) do
    {
      user:
        {
          email: user.email,
          password: password
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
      expect(attributes[:id]).to eq(user.id)
      expect(attributes[:email]).to eq(user.email)
      expect(attributes[:username]).to eq(user.username)
      expect(attributes[:uid]).to eq(user.uid)
      expect(attributes[:provider]).to eq('email')
      expect(attributes[:firstName]).to eq(user.first_name)
      expect(attributes[:lastName]).to eq(user.last_name)
    end

    it 'returns a valid client and access token' do
      token = response.header['access-token']
      client = response.header['client']
      expect(user.reload.valid_token?(token, client)).to be_truthy
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

    it 'return errors upon failure' do
      subject

      expect(response).to be_unauthorized
      expected_response = {
        errors: ['Invalid login credentials. Please try again.'], success: false
      }.with_indifferent_access
      expect(json).to eq(expected_response)
    end
  end
end
