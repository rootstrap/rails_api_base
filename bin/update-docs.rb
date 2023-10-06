#!/usr/bin/env ruby

require 'yaml'
require 'active_support/core_ext/hash/deep_merge'

if ENV['PARALLEL_TESTS_CONCURRENCY']
  begin
    system "OPENAPI=1 bundle exec parallel_rspec -n #{ENV['PARALLEL_TESTS_CONCURRENCY']} spec/requests/api/ -o '--seed 1993'"
    file = YAML.safe_load(File.read('./doc/openapi.yaml'))
    (2..ENV['PARALLEL_TESTS_CONCURRENCY'].to_i).each do |number|
      path = "./doc/openapi#{number}.yaml"
      file.deep_merge!(YAML.safe_load(File.read(path)))
    end
    File.write('./doc/openapi.yaml', YAML.dump(file))
  rescue Errno::ENOENT => exception
    puts exception
  ensure
    exec 'git clean -f doc/openapi?.yaml'
  end
else
  exec 'OPENAPI=1 bundle exec rspec spec/requests/api/ --seed 1993'
end

