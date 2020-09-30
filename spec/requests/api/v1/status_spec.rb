require 'rails_helper'

describe 'GET api/v1/status', type: :request do
  before do
    get api_v1_status_path, as: :json
  end

  it 'returns status 200 ok' do
    expect(response).to be_successful
  end

  it 'returns the api status' do
    expect(json['online']).to be true
  end
end
