#!/usr/bin/env ruby
require 'json'

data = JSON.parse(ARGV[0])

formatted_secrets = data.map do |param|
  param_name = param['Name'].split('/').last.upcase
"#{param_name}=#{param['ARN']}"
end.join('\n')

puts formatted_secrets
