# frozen_string_literal: true

require 'rails_helper'

describe 'GET api/v1/status' do
  before do
    get api_v1_status_path
  end

  it 'returns status 200 ok' do
    expect(response).to be_successful
  end

  it 'returns the api status' do
    expect(json['online']).to be true
  end
end
