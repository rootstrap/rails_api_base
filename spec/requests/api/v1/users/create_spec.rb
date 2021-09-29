describe 'POST api/v1/users/', type: :request do
  let(:user)            { User.last }
  let(:failed_response) { 422 }

  describe 'POST create' do
    subject { post user_registration_path, params: params }

    let(:username)              { 'test' }
    let(:email)                 { 'test@test.com' }
    let(:password)              { '12345678' }
    let(:password_confirmation) { '12345678' }
    let(:first_name)            { 'Johnny' }
    let(:last_name)             { 'Perez' }

    let(:params) do
      {
        user: {
          username: username,
          email: email,
          password: password,
          password_confirmation: password_confirmation,
          first_name: first_name,
          last_name: last_name
        }
      }
    end

    it_behaves_like 'does not check authenticity token'
    it_behaves_like 'there must not be a Set-Cookie in Header'

    it 'returns a successful response' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'creates the user' do
      expect { subject }.to change(User, :count).by(1)
    end

    it 'returns the user' do
      subject

      expect(attributes[:id]).to eq(user.id)
      expect(attributes[:email]).to eq(user.email)
      expect(attributes[:username]).to eq(user.username)
      expect(attributes[:uid]).to eq(user.uid)
      expect(attributes[:provider]).to eq('email')
      expect(attributes[:firstName]).to eq(user.first_name)
      expect(attributes[:lastName]).to eq(user.last_name)
    end

    context 'when the email is not correct' do
      let(:email) { 'invalid_email' }

      it 'does not create a user' do
        expect { subject }.not_to change { User.count }
      end

      it 'does not return a successful response' do
        subject
        expect(response.status).to eq(failed_response)
      end
    end

    context 'when the password is incorrect' do
      let(:password)              { 'short' }
      let(:password_confirmation) { 'short' }
      let(:new_user)              { User.find_by(email: email) }

      it 'does not create a user' do
        subject
        expect(new_user).to be_nil
      end

      it 'does not return a successful response' do
        subject
        expect(response.status).to eq(failed_response)
      end
    end

    context 'when passwords don\'t match' do
      let(:password)              { 'shouldmatch' }
      let(:password_confirmation) { 'dontmatch' }
      let(:new_user)              { User.find_by(email: email) }

      it 'does not create a user' do
        subject
        expect(new_user).to be_nil
      end

      it 'does not return a successful response' do
        subject
        expect(response.status).to eq(failed_response)
      end
    end
  end
end
