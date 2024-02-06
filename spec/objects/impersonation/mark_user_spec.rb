# frozen_string_literal: true

describe Impersonation::MarkUser do
  let(:user) { create(:user) }

  describe '#mark!' do
    subject { described_class.new(user, access_token).mark! }

    context 'when access_token is valid' do
      let(:token) { user.create_token('impersonated_by' => 1).tap { user.save! } }
      let(:access_token) { user.build_auth_headers(token.token, token.client)['access-token'] }

      it 'sets the impersonated_by attribute' do
        expect { subject }.to change(user, :impersonated_by).from(nil).to(1)
      end
    end

    context 'when the user token does not have the impersonated_by key' do
      let(:token) { user.create_token.tap { user.save! } }
      let(:access_token) { user.build_auth_headers(token.token, token.client)['access-token'] }

      it 'sets the impersonated_by attribute' do
        expect { subject }.not_to change(user, :impersonated_by).from(nil)
      end
    end

    context 'when access_token is not valid' do
      let(:token) { user.create_token.tap { user.save! } }
      let(:access_token) { 'invalid' }

      it 'sets the impersonated_by attribute' do
        expect { subject }.not_to change(user, :impersonated_by).from(nil)
      end
    end

    context 'when user does not exist' do
      let(:user) { nil }
      let(:access_token) { nil }

      it 'does not fail' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
