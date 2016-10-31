# encoding: utf-8

require 'rails_helper'

describe Api::V1::SessionsController do
  let(:password) { 'mypass123' }
  let!(:user)    { create(:user, password: password) }

  describe 'POST create' do
    let(:email)    { user.email }
    let(:params)   { { user: { email: email, password: password }, format: :json } }
    context 'with valid login' do
      it 'returns a successful response' do
        post :create, params: params
        expect(response).to have_http_status(:success)
      end

      it 'returns a valid client and access token' do
        post :create, params: params
        token = response.header['access-token']
        client = response.header['client']
        expect(user.reload.valid_token?(token, client)).to be_truthy
      end
    end

    context 'with invalid login' do
      shared_context 'returns invalid credentials' do
        it 'returns an error' do
          post :create, params: params
          expect(parsed_response['errors']).to include(error_message)
        end
      end
      let(:error_message) { 'Invalid login credentials. Please try again.' }
      context 'when the password is incorrect' do
        let!(:user)    { create(:user, password: 'another_password') }
        let(:password) { 'badPassword' }

        it_behaves_like 'returns invalid credentials'
      end

      context 'when the email is not correct' do
        let(:email) { 'bademail@eaea.com' }

        it_behaves_like 'returns invalid credentials'
      end
    end
  end

  describe 'POST facebook' do
    shared_context 'fail to login with facebook' do
      it 'does not returns a successful response' do
        post :facebook, params: params
        expect(response).to_not have_http_status(:success)
      end

      it 'does not create an user' do
        expect { post :facebook, params: params }.to change(User, :count).by(0)
      end
    end
    context 'with valid params' do
      let(:params) do
        {
          access_token: '123456',
          format: 'json'
        }
      end

      it 'returns a successful response' do
        post :facebook, params: params
        expect(response).to have_http_status(:success)
      end

      it 'creates an user' do
        expect { post :facebook, params: params }.to change(User, :count).by(1)
      end

      it 'assigns the information properly' do
        post :facebook, params: params
        user = User.last
        expect(user.first_name).to eq 'Test'
        expect(user.email).to eq 'test@facebook.com'
        expect(user.uid).to eq '1234567890'
        expect(user.provider).to eq 'facebook'
        expect(user.encrypted_password).to be_present
      end

      it 'returns a valid client and access token' do
        post :facebook, params: params
        token = response.header['access-token']
        client = response.header['client']
        user = User.last
        expect(user.reload.valid_token?(token, client)).to be_truthy
      end

      context 'with an user having the same email' do
        before do
          FactoryGirl.create :user, email: 'test@facebook.com'
        end

        it_behaves_like 'fail to login with facebook'
      end

      context 'without facebook email' do
        let(:params) do
          {
            access_token: 'without_email',
            format: 'json'
          }
        end

        it 'creates an user' do
          expect { post :facebook, params: params }.to change(User, :count).by(1)
        end
      end

      context 'the user has already logged with facebook' do
        before do
          params = {
            email: 'test@facebook.com',
            provider: 'facebook',
            uid: '1234567890'
          }
          FactoryGirl.create :user, params
        end

        it 'returns a successful response' do
          post :facebook, params: params
          expect(response).to have_http_status(:success)
        end

        it 'does not create an user' do
          expect { post :facebook, params: params }.to change(User, :count).by(0)
        end
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          access_token: 'invalid',
          format: 'json'
        }
      end

      it_behaves_like 'fail to login with facebook'
    end
  end

  describe 'DELETE destroy' do
    before do
      auth_request(user)
    end

    it 'returns a successful response' do
      delete :destroy
      expect(response).to have_http_status(:success)
    end

    it 'can not do twice' do
      delete :destroy
      delete :destroy
      expect(response).to_not have_http_status(:success)
    end
  end
end
