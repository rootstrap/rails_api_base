# frozen_string_literal: true

require 'rails_helper'

describe 'GET api/v1/settings/must_update' do
  subject { get must_update_api_v1_settings_path, params: }

  let(:params) do
    {
      device_version: '1.0'
    }
  end

  context 'with correct settings' do
    before { create(:setting_version) }

    it 'return success' do
      subject
      expect(response).to be_successful
    end

    it 'returns no need to update' do
      subject
      expect(json['must_update']).to be(false)
    end
  end

  context 'with incorrect settings' do
    before { create(:setting_version, value: '2.0') }

    it 'returns it needs to update' do
      subject
      expect(json['must_update']).to be(true)
    end
  end

  context 'without setting min version record' do
    it 'returns no need to update' do
      subject
      expect(json['must_update']).to be(false)
    end
  end
end
