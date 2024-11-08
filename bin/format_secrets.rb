#!/usr/bin/env ruby
require 'json'

data = JSON.parse(ENV['SSM_PARAMETERS_JSON'])

formatted_secrets = data.map { |param| "#{param["Name"]}=#{param["ARN"]}" }.join("\n")

puts formatted_secrets
