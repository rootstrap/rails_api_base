#!/usr/bin/env ruby

require 'yaml'
require 'active_support/core_ext/hash/deep_merge'

PATH = './doc/openapi.yaml'.freeze

# sed command implementation is different for GNU and macOS
def sed_i(regex)
  if /darwin/.match?(RUBY_PLATFORM)
    system "sed -i '' -E 's/#{regex}/g' #{PATH}"
  else
    system "sed -i 's/#{regex}/g' #{PATH}"
  end
end

def remove_white_spaces
  if /darwin/.match?(RUBY_PLATFORM)
    sed_i("[ '$'\t'']+$/")
  else
    sed_i("[ \t]*$/")
  end
end

if ENV['SEQUENTIAL_SPECS']
  exec 'OPENAPI=1 bundle exec rspec spec/requests/api/ --seed 1993'
else
  begin
    concurrency = ENV.fetch('PARALLEL_TESTS_CONCURRENCY', 8)
    system "OPENAPI=1 bundle exec parallel_rspec -n #{concurrency} spec/requests/api/ -o '--seed 1993'"
    file = YAML.safe_load(File.read(PATH))
    (2..concurrency.to_i).each do |number|
      file.deep_merge!(YAML.safe_load(File.read("./doc/openapi#{number}.yaml")))
    end
    # Sort endpoints alphabetically
    file['paths'] = file['paths'].sort.to_h
    # Freeze all created_at & updated_at dates to 1/1/2023
    file = YAML.dump(file).gsub(/(created_at|updated_at): '.*'/, "\0: '2023-01-01T00:00:00.000Z'")
    File.write(PATH, file)
    remove_white_spaces
  rescue Errno::ENOENT => exception
    puts exception
  ensure
    `git clean -f ./doc/openapi?.yaml`
  end
end

