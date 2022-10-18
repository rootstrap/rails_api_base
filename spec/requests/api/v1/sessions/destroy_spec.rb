describe 'DELETE api/v1/users/sign_out', type: :request do
  let(:user) { create(:user) }

  context 'with a valid token' do
    it 'returns a successful response' do
      delete destroy_user_session_path, headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'decrements the amount of user tokens' do
      headers = auth_headers
      expect {
        delete destroy_user_session_path, headers:, as: :json
      }.to change { user.reload.tokens.size }.by(-1)
    end
  end

  context 'without a valid token' do
    it 'returns not found response' do
      delete destroy_user_session_path, headers: {}, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end
end
