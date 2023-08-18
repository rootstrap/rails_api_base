# frozen_string_literal: true

require 'rake'

RSpec.describe 'FeatureFlags', :rake do
  before do
    task_defined = Rake::Task.task_defined?('feature_flags:initialize')
    Rails.application.load_tasks unless task_defined
  end

  describe 'initialize' do
    let(:feature_flags) do
      {
        'test_flag' => {
          'description' => 'Test description',
          'owner' => 'Test owner',
          'removal_ticket' => 'Test ticket'
        }
      }
    end

    before do
      allow(YAML).to receive(:load_file).and_return(feature_flags)
    end

    it 'registers the feature flags from config/feature-flags.yml' do
      expect(Flipper.features.count).to eq 0
      Rake::Task['feature_flags:initialize'].invoke
      expect(Flipper.features.count).to eq 1
      expect(Flipper.features.first.name).to eq 'test_flag'
      expect(Flipper.features.first.state).to eq :off
    end
  end
end
