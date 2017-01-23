# encoding: utf-8

require 'rails_helper'
require 'addressable/uri'

describe Api::V1::PasswordsController do
  let!(:user)          { create(:user, password: 'mypass123') }
  let(:failed_response) { 401 }

  describe 'POST create' do
    before :each do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end

    context 'with valid params' do
      let(:params) { { email: user.email, format: 'json' } }

      it 'returns a successful response' do
        post :create, params: params
        expect(response).to have_http_status(:success)
      end

      it 'sends an email' do
        expect { post :create, params: params }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'with invalid params' do
      it 'does not return a successful response' do
        post :create, params: { email: 'notvalid@example.com', format: 'json' }
        expect(response.status).to eq(404)
      end

      it 'does not send an email' do
        expect do
          post :create, params: { email: 'notvalid@example.com', format: 'json' }
        end.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end

  describe 'GET edit' do
    let(:password_token) { user.send(:set_reset_password_token) }
    let(:params) do
      {
        reset_password_token: password_token,
        redirect_url: ENV['PASSWORD_RESET_URL']
      }
    end

    it 'returns a the access token, uid and client id' do
      get :edit, params: params
      expect(response.header['Location']).to include('token')
      expect(response.header['Location']).to include('uid')
      expect(response.header['Location']).to include('client_id')
    end
  end

  # This tests will be skipped while the following issue is being attended
  # https://github.com/toptier/rails5_api_base/issues/30
  describe 'PUT update', on_refactor: true do
    let(:password_token) { user.send(:set_reset_password_token) }
    before do
      params = {
        reset_password_token: password_token,
        redirect_url: ENV['PASSWORD_RESET_URL']
      }
      get :edit, params: params
      edit_response_params = Addressable::URI.parse(response.header['Location']).query_values
      request.headers['access-token'] = edit_response_params['token']
      request.headers['uid'] = edit_response_params['uid']
      request.headers['client'] = edit_response_params['client_id']
    end
    let(:new_password) { '123456789' }
    let(:params) do
      {
        password: new_password,
        password_confirmation: new_password,
        format: 'json'
      }
    end

    context 'with valid params' do
      it 'returns a successful response' do
        put :update, params: params
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      it 'does not change the password if confirmation does not match' do
        params[:password_confirmation] = 'anotherpass'
        put :update, params: params
        expect(response.status).to eq(422)
      end
    end
  end
end
