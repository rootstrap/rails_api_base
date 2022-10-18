describe 'GET api/v1/users/passwords/edit', type: :request do
  let(:user)           { create(:user, password: 'mypass123') }
  let(:password_token) { user.send(:set_reset_password_token) }
  let(:params) do
    {
      reset_password_token: password_token,
      redirect_url: ENV.fetch('PASSWORD_RESET_URL', nil)
    }
  end

  it 'returns a the access token, uid and client id' do
    get edit_user_password_path, params: params
    expect(response.header['Location']).to include('token')
    expect(response.header['Location']).to include('uid')
    expect(response.header['Location']).to include('client_id')
  end
end
