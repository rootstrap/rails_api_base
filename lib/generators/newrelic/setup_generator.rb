# frozen_string_literal: true

module Newrelic
  class SetupGenerator < Rails::Generators::Base
    NEWRELIC_GEM_NAME = 'newrelic_rpm'
    NEWRELIC_GEM_USED_REGEXP = /gem.*\b#{NEWRELIC_GEM_NAME}\b.*/

    desc 'This generator adds the newrelic gem and creates all the needed config files.'
    argument :app_name, type: :string, required: true

    def add_new_relic_gem
      gem(NEWRELIC_GEM_NAME) unless newrelic_installed?

      run 'bundle install'

      require 'new_relic/cli/command'
      NewRelic::Cli::Install.new(quiet: true, app_name:, license_key: "<%= ENV['NEW_RELIC_API_KEY'] %>").run

      append_to_file '.env.sample', 'NEW_RELIC_API_KEY='
    end

    private

    def newrelic_installed?
      in_root do
        return File.read('Gemfile').match?(NEWRELIC_GEM_USED_REGEXP)
      end
    end
  end
end
