require_relative '../support/acceptance_tests_helper'

resource 'Status' do
  header 'Content-Type', 'application/json'

  route 'api/v1/status', 'Status' do
    get 'Get' do
      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end
end
