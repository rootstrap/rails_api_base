require 'rails_helper'

describe 'POST api/v1/users/facebook', type: :request do
  let(:user)              { create(:user) }
  let(:facebook_path)     { facebook_api_v1_user_path }
  let(:facebook_api_path) { 'https://graph.facebook.com/me' }
  let(:facebook_response) do
    {
      first_name: 'Test',
      last_name: 'test',
      email: 'test@facebook.com',
      id: '1234567890'
    }
  end

  shared_examples 'fail to login with facebook' do
    it 'does not returns a successful response' do
      post facebook_path, params: params, as: :json
      expect(response).to_not have_http_status(:success)
    end

    it 'does not create an user' do
      expect { post facebook_path, params: params, as: :json }.to change(User, :count).by(0)
    end
  end

  context 'with valid params' do
    let(:params) do
      {
        access_token: '123456'
      }
    end
    before do
      stub_request(:get, facebook_api_path)
        .with(query: hash_including(access_token: '123456', fields: 'email,first_name,last_name'))
        .to_return(status: 200, body: facebook_response.to_json)
    end

    it 'returns a successful response' do
      post facebook_path, params: params, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'creates an user' do
      expect { post facebook_path, params: params, as: :json }.to change(User, :count).by(1)
    end

    it 'assigns the information properly' do
      post facebook_path, params: params, as: :json
      user = User.last
      expect(user.first_name).to eq 'Test'
      expect(user.email).to eq 'test@facebook.com'
      expect(user.uid).to eq '1234567890'
      expect(user.provider).to eq 'facebook'
      expect(user.encrypted_password).to be_present
    end

    it 'returns a valid client and access token' do
      post facebook_path, params: params, as: :json
      token = response.header['access-token']
      client = response.header['client']
      user = User.last
      expect(user.reload.valid_token?(token, client)).to be_truthy
    end

    context 'with an user having the same email' do
      before do
        create :user, email: 'test@facebook.com'
      end

      it_behaves_like 'fail to login with facebook'

      it 'shows the right error' do
        post facebook_path, params: params, as: :json
        expect(json[:error]).to include 'already registered'
      end
    end

    context 'without facebook email' do
      let(:params) do
        {
          access_token: 'without_email'
        }
      end
      before do
        facebook_response[:email] = ''
        fields = 'email,first_name,last_name'
        stub_request(:get, facebook_api_path)
          .with(query: hash_including(access_token: 'without_email', fields: fields))
          .to_return(status: 200, body: facebook_response.to_json)
      end

      it 'creates an user' do
        expect { post facebook_path, params: params, as: :json }.to change(User, :count).by(1)
      end
    end

    context 'the user has already logged with facebook' do
      before do
        params = {
          email: 'test@facebook.com',
          provider: 'facebook',
          uid: '1234567890'
        }
        create :user, params
      end

      it 'returns a successful response' do
        post facebook_path, params: params, as: :json
        expect(response).to have_http_status(:success)
      end

      it 'does not create an user' do
        expect { post facebook_path, params: params, as: :json }.to change(User, :count).by(0)
      end
    end
  end

  context 'with invalid params' do
    let(:params) do
      {
        access_token: 'invalid'
      }
    end
    before do
      facebook_response = {
        error: {
          message: 'Expired token',
          type: 'OAuthException',
          code: 190
        }
      }
      stub_request(:get, facebook_api_path)
        .with(query: hash_including(access_token: 'invalid', fields: 'email,first_name,last_name'))
        .to_return(status: 400, body: facebook_response.to_json)
    end

    it_behaves_like 'fail to login with facebook'

    it 'shows the right error' do
      post facebook_path, params: params, as: :json
      expect(json[:error]).to include 'Not Authorized'
    end
  end
end
