# frozen_string_literal: true

describe 'POST api/v1/users' do
  subject { post user_registration_path, params:, as: :json }

  let(:user) { User.last }
  let(:email) { 'test@example.com' }

  let(:params) do
    {
      user: {
        username: 'test',
        email:,
        password: '12345678',
        password_confirmation: '12345678',
        first_name: 'Johnny',
        last_name: 'Perez'
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

  it 'returns the user data', :aggregate_failures do
    subject
    expect(json[:user][:id]).to eq(user.id)
    expect(json[:user][:email]).to eq(user.email)
    expect(json[:user][:username]).to eq(user.username)
    expect(json[:user][:uid]).to eq(user.uid)
    expect(json[:user][:provider]).to eq('email')
    expect(json[:user][:first_name]).to eq(user.first_name)
    expect(json[:user][:last_name]).to eq(user.last_name)
  end

  context 'when the email is not correct' do
    let(:email) { 'invalid_email' }

    it 'does not create a user' do
      expect { subject }.not_to change(User, :count)
    end

    it 'does not return a successful response' do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'when the password is incorrect' do
    let(:new_user) { User.find_by(email:) }

    before do
      params[:user].merge!({ password: 'short', password_confirmation: 'short' })
    end

    it 'does not create a user' do
      subject
      expect(new_user).to be_nil
    end

    it 'does not return a successful response' do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context 'when passwords don\'t match' do
    let(:new_user) { User.find_by(email:) }

    before do
      params[:user].merge!({ password: 'shouldmatch', password_confirmation: 'dontmatch' })
    end

    it 'does not create a user' do
      subject
      expect(new_user).to be_nil
    end

    it 'does not return a successful response' do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
