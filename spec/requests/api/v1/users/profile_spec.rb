describe 'GET api/v1/user/profile', type: :request do
  let(:user) { create(:user) }

  it 'returns success' do
    get profile_api_v1_user_path, headers: auth_headers, as: :json
    expect(response).to have_http_status(:success)
  end

  it 'returns user\'s data' do
    get profile_api_v1_user_path, headers: auth_headers, as: :json

    expect(json[:user][:id]).to eq user.id
    expect(json[:user][:name]).to eq user.full_name
  end
end
