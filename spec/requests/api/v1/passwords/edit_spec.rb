# frozen_string_literal: true

describe 'GET api/v1/users/passwords/edit' do
  subject { get edit_user_password_path, params: }

  let(:user) { create(:user, password: 'mypass123') }
  let(:password_token) { user.send(:set_reset_password_token) }
  let(:params) do
    {
      reset_password_token: password_token,
      redirect_url: ENV.fetch('PASSWORD_RESET_URL', nil)
    }
  end

  before { subject }

  it 'returns a the access token, uid and client id' do
    expect(response.header['Location']).to include('token')
  end

  it 'returns the uid' do
    expect(response.header['Location']).to include('uid')
  end

  it 'returns the client id' do
    expect(response.header['Location']).to include('client_id')
  end
end
