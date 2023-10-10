# frozen_string_literal: true

module Retry
  class CreateIssue
    attr_reader :repo, :client

    def initialize
      @repo = ENV.fetch('REPO', nil)
      @github_token = ENV.fetch('GITHUB_TOKEN', nil)
      @client = Octokit::Client.new(access_token: @github_token)
    end

    def create_issue(title, body)
      issue = client.create_issue(repo, title, body)
      pp "Issue created: #{issue.html_url}"
    rescue StandardError => e
      p e.message
    end
  end
end
