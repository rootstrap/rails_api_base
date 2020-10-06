require_relative '../support/acceptance_tests_helper'

resource 'Settings' do
  header 'Content-Type', 'application/json'
  header 'access-token', :access_token_header
  header 'client', :client_header
  header 'uid', :uid_header

  let(:user) { create(:user) }

  route 'api/v1/settings/must_update', 'Must Update' do
    let(:request) do
      {
        device_version: '1.0'
      }
    end

    get 'Get' do
      example 'Ok' do
        create(:setting_version)
        do_request(request)

        expect(status).to eq 200
      end

      example 'Bad' do
        create(:setting_version, value: '2.0')
        do_request(request)

        expect(status).to eq 200
      end
    end
  end
end
