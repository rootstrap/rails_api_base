# frozen_string_literal: true

RSpec.describe API::Concerns::Impersonation::SetHeaders, type: :controller do
  controller(API::V1::APIController) do
    include API::Concerns::Impersonation::SetHeaders

    def show
      byebug
      render json: {}
    end
  end

  before { routes.draw { get 'show' => 'anonymous#show' } }

  describe '#show' do
    subject { get :show, headers: auth_headers, format: :json }

    let(:user) { create(:user) }

    context 'when user has a valid session' do
      it 'does not return the impersonated header' do
        byebug
        expect(response.headers).not_to include('impersonated')
      end

      context 'when the session is being impersonated' do
        let(:auth_headers) do
          token = user.create_token('impersonated_by' => 1).tap { user.save! }
          user.build_auth_headers(token.token, token.client)
        end

        it 'does return the impersonated header' do
          expect(response.headers).to include('impersonated')
        end
      end
    end
  end
end
