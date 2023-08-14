FEATURES_YML_PATH = 'config/feature-flags.yml'.freeze

namespace :feature_flags do
  desc 'Regiser new feature flags from config/feature-flags.yml'
  task initialize: :environment do
    YAML.load_file(FEATURES_YML_PATH, fallback: {}).each do |key, _options|
      next if Flipper.exist?(key)
      
      Flipper.add key
    end
  end
end
