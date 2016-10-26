begin
  ENV.update YAML.load(File.read('config/application.yml'))
rescue
  puts "You've to add a correct application.yml file"
end
