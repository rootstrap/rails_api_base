module Retry
  class PullRequestComment
    attr_reader :repo, :pull_request_number, :client

    def initialize
      @repo = ENV['REPO']
      @pull_request_number = ENV['PULL_REQUEST_NUMBER']
      @github_token = ENV['GITHUB_TOKEN']
      @client = Octokit::Client.new(access_token: @github_token)
    end

    def comment(message)
      pp "repo: #{repo}"
      pp "Payload number: #{ENV['PAYLOAD_NUMBER']}"
      pp "pr: #{pull_request_number}"
      pp message

      options = { event: 'COMMENT', body: message }
      client.create_pull_request_review(repo, pull_request_number, options)
    rescue StandardError => e
      p e.message
    end
  end
end
