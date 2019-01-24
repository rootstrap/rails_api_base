require 'rails_helper'

describe 'GET api/v1/users/:id', type: :request do
  let(:user) { create(:user) }

  it 'returns success' do
    get api_v1_user_path, headers: auth_headers, as: :json
    expect(response).to have_http_status(:success)
  end

  it "returns the logged in user's data" do
    get api_v1_user_path, headers: auth_headers, as: :json

    expect(json[:user][:id]).to eq user.id
    expect(json[:user][:first_name]).to eq user.first_name
  end
end
