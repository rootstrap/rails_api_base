# frozen_string_literal: true

require 'rails_helper'

describe 'GET api/v1/settings/must_update' do
  subject(:endpoint) { get must_update_api_v1_settings_path, params: }

  let(:params) do
    {
      device_version: '1.0'
    }
  end

  context 'with correct settings' do
    before do
      create(:setting_version)
    end

    it 'return success' do
      endpoint
      expect(response).to be_successful
    end

    it 'returns no need to update' do
      endpoint
      expect(json['must_update']).to be(false)
    end
  end

  context 'with incorrect settings' do
    before do
      create(:setting_version, value: '2.0')
    end

    it 'returns it needs to update' do
      endpoint
      expect(json['must_update']).to be(true)
    end
  end

  context 'without setting min version record' do
    it 'returns no need to update' do
      endpoint
      expect(json['must_update']).to be(false)
    end
  end
end
