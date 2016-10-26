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
