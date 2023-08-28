# frozen_string_literal: true

Flipper::UI.configure do |config|
  config.descriptions_source = lambda { |_keys|
    YAML.load_file('config/feature-flags.yml', fallback: {}).transform_values do |value|
      value['description']
    end
  }
  config.show_feature_description_in_list = true
end
