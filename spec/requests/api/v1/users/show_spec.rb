describe 'GET api/v1/user', type: :request do
  let(:user) { create(:user) }
  subject { get api_v1_user_path, headers: auth_headers }

  it 'returns success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it "returns the logged in user's data" do
    subject

    expect(attributes[:id]).to eq(user.id)
  end

  context 'when record is not found' do
    it 'returns status 404 not found' do
      allow_any_instance_of(Api::V1::UsersController).to receive(
        :current_user
      ).and_raise(ActiveRecord::RecordNotFound)
      subject

      expect(response).to have_http_status(:not_found)
    end
  end
end
