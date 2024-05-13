# frozen_string_literal: true

RSpec.describe 'API::Concerns::Impersonation::Hooks', openapi: false do
  before do
    stub_const('FakeController', Class.new(API::V1::APIController) do
      include API::Concerns::Impersonation::Hooks
      skip_after_action :verify_authorized

      def show
        render json: { 'current_user.impersonated_by' => current_user.impersonated_by }
      end
    end)

    Rails.application.routes.draw do
      get '/show' => 'fake#show'
    end
  end

  after do
    Rails.application.reload_routes!
  end

  describe '#show' do
    subject do
      get '/show', headers: auth_headers
    end

    let(:user) { create(:user) }

    context 'with a normal session' do
      it 'does not return the impersonated header' do
        subject
        expect(response.headers).not_to include('impersonated')
      end

      it 'current_user.impersonated_by is nil' do
        subject
        expect(json).to eq('current_user.impersonated_by' => nil)
      end
    end

    context 'with an impersonated session' do
      let(:auth_headers) do
        token = user.create_token('impersonated_by' => 1).tap { user.save! }
        user.build_auth_headers(token.token, token.client)
      end

      it 'returns the impersonated header' do
        subject
        expect(response.headers).to include({ 'impersonated' => true })
      end

      it 'current_user.impersonated_by is the admin id' do
        subject
        expect(json).to eq('current_user.impersonated_by' => 1)
      end
    end
  end
end
