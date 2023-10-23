# frozen_string_literal: true

module Retry
  class PullRequestComment
    attr_reader :repo, :pull_request_number, :client

    def initialize
      @repo = ENV.fetch('REPO', nil)
      @pull_request_number = ENV.fetch('PULL_REQUEST_NUMBER', nil)
      @github_token = ENV.fetch('GITHUB_TOKEN', nil)
      @client = Octokit::Client.new(access_token: @github_token)
    end

    def comment(message)
      return if pull_request_number.blank?

      options = { event: 'COMMENT', body: message }
      client.create_pull_request_review(repo, pull_request_number, options)
    rescue StandardError => error
      puts error.message
    end
  end
end
