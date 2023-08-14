FEATURES_YML_PATH = 'config/feature-flags.yml'.freeze
Flipper::UI.configure do |config|
  config.descriptions_source = lambda { |_keys|
    YAML.load_file(FEATURES_YML_PATH, fallback: {}).transform_values do |value|
      value['description']
    end
  }
  config.show_feature_description_in_list = true
end
