require_relative '../support/acceptance_tests_helper'

resource 'Passwords' do
  header 'Content-Type', 'application/json'
  header 'access-token', :access_token_header
  header 'client', :client_header
  header 'uid', :uid_header

  let(:user) { create(:user) }

  route 'api/v1/users/password', 'Create Password' do
    post 'Create' do
      example 'Ok' do
        do_request(email: user.email)

        expect(status).to eq 200
      end

      example 'Bad' do
        do_request(email: 'notvalid@example.com')

        expect(status).to eq 404
      end
    end
  end

  route 'api/v1/users/password/edit', 'Edit Password' do
    let(:password_token) { user.send(:set_reset_password_token) }
    let(:request) do
      {
        reset_password_token: password_token,
        redirect_url: ENV.fetch('PASSWORD_RESET_URL', nil)
      }
    end

    get 'Edit' do
      example 'Ok' do
        do_request(request)

        expect(status).to eq 302
      end
    end
  end

  route 'api/v1/users/password', 'Update Password' do
    let(:new_password) { '123456789' }
    let(:request) do
      {
        password: new_password,
        password_confirmation: new_password
      }
    end

    put 'Update' do
      example 'Ok' do
        do_request(request)

        expect(status).to eq 200
      end

      example 'Bad' do
        do_request({ password: new_password, password_confirmation: '' })

        expect(status).to eq 422
      end
    end
  end
end
