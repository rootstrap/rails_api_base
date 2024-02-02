# frozen_string_literal: true

RSpec.describe API::Concerns::Impersonation::SetHeaders do
  class FakeController < API::V1::APIController
    include API::Concerns::Impersonation::SetHeaders

    def show
      byebug
      render json: {}
    end
  end

  before do
    Rails.application.routes.draw do
      get '/show' => 'fake#show'
    end
  end

  describe '#show' do
    subject do
      get '/show', headers: auth_headers, as: :json
    end

    let(:user) { create(:user) }

    context 'when user has a valid session' do
      it 'does not return the impersonated header' do
        subject
        expect(response.headers).not_to include('impersonated')
      end

      context 'when the session is being impersonated' do
        let(:auth_headers) do
          token = user.create_token('impersonated_by' => 1).tap { user.save! }
          user.build_auth_headers(token.token, token.client)
        end

        it 'does return the impersonated header' do
          subject
          byebug
          expect(response.headers).to include('impersonated')
        end
      end
    end
  end
end
