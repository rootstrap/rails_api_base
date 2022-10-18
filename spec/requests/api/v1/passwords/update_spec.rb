describe 'PUT api/v1/users/passwords/', type: :request do
  let(:user)           { create(:user, password: 'mypass123') }
  let(:password_token) { user.send(:set_reset_password_token) }
  let(:headers) do
    params = {
      reset_password_token: password_token,
      redirect_url: ENV.fetch('PASSWORD_RESET_URL', nil)
    }
    get edit_user_password_path, params: params, headers: auth_headers
    edit_response_params = Addressable::URI.parse(response.header['Location']).query_values
    {
      'access-token' => edit_response_params['token'],
      'uid' => edit_response_params['uid'],
      'client' => edit_response_params['client_id']
    }
  end
  let(:new_password) { '123456789' }
  let(:params) do
    {
      password: new_password,
      password_confirmation: new_password
    }
  end

  context 'with valid params' do
    it 'returns a successful response' do
      put user_password_path, params: params, headers: headers, as: :json
      expect(response).to have_http_status(:success)
    end
  end

  context 'with invalid params' do
    it 'does not change the password if confirmation does not match' do
      params[:password_confirmation] = 'anotherpass'
      put user_password_path, params: params, headers: headers, as: :json
      expect(response.status).to eq(422)
    end
  end
end
