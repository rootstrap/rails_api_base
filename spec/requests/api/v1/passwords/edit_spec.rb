# frozen_string_literal: true

describe 'GET api/v1/users/passwords/edit' do
  subject { get edit_user_password_path, params: }

  let(:user) { create(:user, password: 'mypass123') }
  # We have to fix the raw token so this doesn't change in the docs
  let(:raw) { '96BuszWmzDxRqXYzc_Mf' }
  let(:key) { Devise.token_generator.send(:key_for, 'reset_password_token') }
  let(:enc) { OpenSSL::HMAC.hexdigest('SHA256', key, raw) }
  let(:params) do
    {
      reset_password_token: raw,
      redirect_url: ENV.fetch('PASSWORD_RESET_URL', nil)
    }
  end

  before do
    # This is what Devise does behind the scenes in #set_reset_password_token
    user.reset_password_token = enc
    user.reset_password_sent_at = Time.current
    user.save!(validate: false)
    subject
  end

  it 'returns a the access token, uid and client id' do
    expect(response.header['Location']).to include('token')
  end

  it 'returns the uid' do
    expect(response.header['Location']).to include('uid')
  end

  it 'returns the client id' do
    expect(response.header['Location']).to include('client_id')
  end
end
