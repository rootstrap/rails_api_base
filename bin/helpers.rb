require 'open3'

begin
  require 'dotenv/load'
rescue StandardError, LoadError => e
  e
end

def running_with_docker?
  ENV['DOCKER_ENABLED'] == 'true' && docker_compose_installed? && docker_running?
end

def docker_compose_installed?
  system('which docker-compose > /dev/null 2>&1')
end

def docker_running?
  system('docker ps > /dev/null 2>&1')
end
