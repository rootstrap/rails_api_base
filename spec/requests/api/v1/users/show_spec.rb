describe 'GET api/v1/users/:id', type: :request do
  let(:user) { create(:user) }
  subject { get api_v1_user_path, headers: auth_headers, as: :json }

  it_behaves_like 'there must not be a Set-Cookie in Header'

  it 'returns success' do
    subject
    expect(response).to have_http_status(:success)
  end

  it "returns the logged in user's data" do
    subject
    expect(json[:user][:id]).to eq(user.id)
    expect(json[:user][:name]).to eq(user.full_name)
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
