# frozen_string_literal: true

require 'rails_helper'

describe 'GET api/v1/delayed_jobs' do
  context 'when there are delayed jobs in the system' do
    before do
      # Stub the Delayed::Job.count method to return 3
      allow(Delayed::Job).to receive(:count).and_return(3)
      
      # Make the request
      get api_v1_delayed_jobs_path
    end

    it 'returns status 200 ok' do
      expect(response).to be_successful
    end

    it 'returns the correct count of delayed jobs' do
      expect(json['count']).to eq(3)
    end
  end

  context 'when there are no delayed jobs in the system' do
    before do
      # Stub the Delayed::Job.count method to return 0
      allow(Delayed::Job).to receive(:count).and_return(0)
      
      # Make the request
      get api_v1_delayed_jobs_path
    end

    it 'returns status 200 ok' do
      expect(response).to be_successful
    end

    it 'returns a count of zero' do
      expect(json['count']).to eq(0)
    end
  end

  context 'when there is an extremely large number of delayed jobs' do
    before do
      # Stub the Delayed::Job.count method to return a very large number
      # Using 10 million as an example of an extremely large number
      allow(Delayed::Job).to receive(:count).and_return(10_000_000)
      
      # Make the request
      get api_v1_delayed_jobs_path
    end

    it 'returns status 200 ok' do
      expect(response).to be_successful
    end

    it 'returns the correct large count of delayed jobs' do
      expect(json['count']).to eq(10_000_000)
    end

    it 'returns the count as a number, not a string' do
      # Ensure the JSON parser maintains the numeric type
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['count']).to be_a(Integer)
    end
  end
end
