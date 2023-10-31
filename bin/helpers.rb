require 'open3'

begin
  require 'dotenv/load'
rescue StandardError, LoadError => e
  e
end

def running_with_docker?
  ENV['DOCKER_ENABLED'] == 'true' && docker_compose_installed? && web_service_running?
end

def docker_compose_installed?
  system('which docker-compose > /dev/null 2>&1')
end

def web_service_running?
  docker_compose_installed? && !web_service.empty?
end

def web_service
  abort("\n** ABORTED: docker-compose not installed **") unless docker_compose_installed?
  out, = Open3.capture2("docker-compose ps --services --filter 'status=running' | grep web")
  out.strip
end
