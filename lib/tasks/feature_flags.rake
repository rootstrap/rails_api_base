# frozen_string_literal: true

namespace :feature_flags do
  desc 'Register new feature flags from config/feature-flags.yml'
  task initialize: :environment do
    YAML.load_file('config/feature-flags.yml', fallback: {}).each do |key, _options|
      next if Flipper.exist?(key)

      Flipper.add key
    end
  end
end
