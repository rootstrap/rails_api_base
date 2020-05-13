require 'rails_helper'

describe 'GET api/v1/status', type: :request do
  context 'with invalid content type' do
    it 'returns status 406 not acceptable' do
      get api_v1_status_path

      expect(response).to have_http_status(:not_acceptable)
    end
  end

  context 'with valid content type' do
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
end
