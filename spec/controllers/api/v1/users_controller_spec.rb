# encoding: utf-8

require 'rails_helper'

describe Api::V1::UsersController do
  render_views
  let!(:user) { create(:user) }
  before do
    auth_request user
  end

  describe 'GET show' do
    it 'returns success' do
      get :show, params: { id: :me, format: :json }
      expect(response).to have_http_status(:success)
    end

    it 'returns user\'s data' do
      get :show, params: { id: :me, format: :json }

      expect(parsed_response['user']['id']).to eq user.id
      expect(parsed_response['user']['first_name']).to eq user.first_name
    end
  end

  describe 'PUT update' do
    let(:params) { { username: 'new username' } }

    context 'with valid params' do
      it 'returns success' do
        put :update, params: { id: :me, user: params, format: 'json' }
        expect(response).to have_http_status(:success)
      end

      it 'updates the user' do
        put :update, params: { id: :me, user: params, format: 'json' }
        expect(user.reload.username).to eq(params[:username])
      end

      it 'returns the user' do
        put :update, params: { id: :me, user: params, format: 'json' }

        expect(parsed_response['user']['id']).to eq user.id
        expect(parsed_response['user']['first_name']).to eq user.first_name
      end
    end

    context 'with invalid data' do
      let(:params) { { email: 'notanemail' } }

      it 'does not return success' do
        put :update, params: { id: :me, user: params, format: 'json' }
        expect(response).to_not have_http_status(:success)
      end

      it 'does not update the user' do
        put :update, params: { id: :me, user: params, format: 'json' }
        expect(user.reload.email).to_not eq(params[:email])
      end

      it 'returns the error' do
        put :update, params: { id: :me, user: params, format: 'json' }
        expect(parsed_response['errors']['email']).to include('is not an email')
      end
    end
  end
end
