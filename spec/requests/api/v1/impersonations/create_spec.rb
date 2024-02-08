# frozen_string_literal: true

describe 'POST api/v1/impersonations' do
  subject { post api_v1_impersonations_path, params:, as: :json }

  let(:params) { { auth: } }

  context 'with valid params' do
    let(:user) { create(:user) }
    let(:auth) { Impersonation::Verifier.new.sign!(user_id: user.id, admin_user_id: 1) }

    it 'returns a successful response' do
      subject

      expect(response).to have_http_status(:success)
    end

    it 'authenticates the user and returns impersonation headers' do
      subject

      expect(response.headers['Authorization']).to be_present
      expect(response.headers['impersonated']).to be true
    end

    it 'returns a valid client and access token' do
      subject

      token = response.headers['access-token']
      client = response.headers['client']

      expect(user.reload).to be_valid_token(token, client)
    end
  end

  context 'with invalid params' do
    context 'when auth is incorrect' do
      let(:auth) { Impersonation::Verifier.new.sign!('this is an error') }

      it 'raises an error' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user_id does not exist' do
      let(:user) { build(:user, id: 9999) }
      let(:auth) { Impersonation::Verifier.new.sign!(user_id: user.id, admin_user_id: 1) }

      it 'raises an error' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
