describe 'PUT api/v1/user/', type: :request do
  let(:user)             { create(:user) }
  let(:api_v1_user_path) { '/api/v1/user' }

  let(:params) do
    {
      data: {
        type: 'user',
        id: user.id,
        attributes: {
          email: email
        }
      }
    }
  end

  context 'with valid params' do
    let(:email) { 'newemail@example.com' }

    it 'returns success' do
      put api_v1_user_path, params: params, headers: auth_headers
      expect(response).to have_http_status(:success)
    end

    it 'updates the user' do
      put api_v1_user_path, params: params, headers: auth_headers
      expect(attributes[:email]).to eq('newemail@example.com')
    end
  end

  context 'with invalid data' do
    let(:email) { '' }

    it 'does not return success' do
      put api_v1_user_path, params: params, headers: auth_headers
      expect(response).to_not have_http_status(:success)
    end

    it 'does not update the user' do
      put api_v1_user_path, params: params, headers: auth_headers
      expect(user.reload.email).not_to eq('')
    end

    it 'returns the error' do
      put api_v1_user_path, params: params, headers: auth_headers
      expect(errors).to include("Email can't be blank")
    end
  end

  context 'with missing params' do
    it 'returns the missing params error' do
      put api_v1_user_path, params: {}, headers: auth_headers

      expect(json_response[:errors].first[:status]).to eq '422'
    end
  end
end
