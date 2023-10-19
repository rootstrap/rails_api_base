#!/usr/bin/env ruby

require 'active_support/core_ext/hash/deep_merge'
require 'fileutils'
require 'yaml'

PATH = './doc/openapi.yaml'.freeze

if ENV['MOVE_TMP_FILES']
  FileUtils.mv(Dir.glob('./tmp/openapi?*.yaml'), './doc/')
end

content = {}
Dir.glob('./doc/openapi?*.yaml').each do |filename|
  content.deep_merge!(YAML.safe_load(File.read(filename)))
end
# Sort endpoints alphabetically and remove duplicate endpoints
content['paths'] = content['paths'].sort.uniq(&:first).to_h
File.write(PATH, YAML.dump(content))
FileUtils.cp(PATH, "./tmp/openapi#{ENV['CI_NODE_INDEX']}.yaml")
