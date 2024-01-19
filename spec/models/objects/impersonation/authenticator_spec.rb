# frozen_string_literal: true

describe Impersonation::Authenticator do
  let(:user) { create(:user) }
  let(:admin_user_id) { 123 }
  let(:signed_data) { Impersonation::Verifier.new.generate_signature(user.id, admin_user_id) }

  describe '#build_auth_headers!' do
    subject { described_class.new(signed_data).build_auth_headers! }

    context 'when signed_data is valid' do

    end

    context 'when signed_data expired' do

    end

    context 'when user_id does not exist' do

    end
  end
end
