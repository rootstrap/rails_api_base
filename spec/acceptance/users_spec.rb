resource 'Users' do
  header 'Content-Type', 'application/json'
  header 'access-token', :access_token_header
  header 'client', :client_header
  header 'uid', :uid_header

  let(:user) { create(:user) }

  route 'api/v1/user', 'Show User' do
    get 'Show' do
      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end

  route '/api/v1/user/profile', 'Show Profile' do
    get 'Profile' do
      example 'Ok' do
        do_request

        expect(status).to eq 200
      end
    end
  end
end
