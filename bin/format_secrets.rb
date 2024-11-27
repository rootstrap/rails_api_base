#!/usr/bin/env ruby
require 'json'

data = JSON.parse(ENV['SSM_PARAMETERS_JSON'])

formatted_secrets = data.map do |param|
  param_name = param["Name"].split('/').last.upcase
"#{param_name}=#{param["ARN"]}"
end.join("\n")

puts formatted_secrets
