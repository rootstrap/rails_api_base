# frozen_string_literal: true

describe Impersonation::Authenticator do
  let(:user) { create(:user) }
  let(:admin_user_id) { 123 }
  let(:signed_data) { Impersonation::Verifier.new.sign!({ user_id: user.id, admin_user_id: }) }

  describe '#authenticate!' do
    subject { described_class.new(signed_data).authenticate! }

    context 'when signed_data is valid' do
      it 'returns and array with the user and the token' do
        response = subject
        token = user.reload.tokens.find { |_t, attr| attr['impersonated_by'] == admin_user_id }.last['token']
        expect(response).to include(user)
        expect(response.last['token_hash'].to_s).to eq(token.to_s)
      end

      it 'removes tokens from previous impersonations' do
        user.create_token(impersonated_by: admin_user_id).tap { user.save! }
        subject

        expect(user.reload.tokens.count).to eq 1
      end
    end

    context 'when signed_data expired' do
      it 'raises an InvalidSignature error' do
        signed_data
        travel_to 10.minutes.from_now do
          expect { subject }.to raise_error(ActiveSupport::MessageVerifier::InvalidSignature)
        end
      end
    end

    context 'when user_id does not exist' do
      let(:user) { build(:user, id: 9999) }

      it 'raises an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound, "Couldn't find User with 'id'=9999")
      end
    end
  end
end
