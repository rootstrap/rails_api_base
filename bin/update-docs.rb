#!/usr/bin/env ruby

require 'yaml'
require 'active_support/core_ext/hash/deep_merge'

# sed command implementation is different for GNU and macOS
def sed_i(file)
  if /darwin/.match?(RUBY_PLATFORM)
    system "sed -i '' -E 's/[ '$'\t'']+$//' #{file}"
  else
    system "sed -i 's/[ \t]*$//' #{file}"
  end
end

if ENV['SEQUENTIAL_SPECS']
  exec 'OPENAPI=1 bundle exec rspec spec/requests/api/ --seed 1993'
else
  begin
    concurrency = ENV.fetch('PARALLEL_TESTS_CONCURRENCY', 8)
    system "OPENAPI=1 bundle exec parallel_rspec -n #{concurrency} spec/requests/api/ -o '--seed 1993'"
    path = './doc/openapi.yaml'
    file = YAML.safe_load(File.read(path))
    (2..concurrency.to_i).each do |number|
      file.deep_merge!(YAML.safe_load(File.read("./doc/openapi#{number}.yaml")))
    end
    # Sort endpoints alphabetically
    file['paths'] = file['paths'].sort.to_h
    File.write(path, YAML.dump(file))
    # Remove trailing whitespaces from doc file
    sed_i(path)
  rescue Errno::ENOENT => exception
    puts exception
  ensure
    `git clean -f ./doc/openapi?.yaml`
  end
end

