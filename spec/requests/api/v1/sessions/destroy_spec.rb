require 'rails_helper'

describe 'DELETE api/v1/users/sign_out', type: :request do
  let(:user) { create(:user) }

  it 'returns a successful response' do
    delete destroy_user_session_path, headers: auth_headers, as: :json
    expect(response).to have_http_status(:success)
  end

  it 'can not do twice' do
    headers = auth_headers # TODO
    delete destroy_user_session_path, headers: headers, as: :json
    delete destroy_user_session_path, headers: headers, as: :json
    expect(response).to_not have_http_status(:success)
  end
end
