# frozen_string_literal: true

describe Impersonation::Headers do
  let(:headers) { described_class.new(user:, access_token:) }
  let(:user) { create(:user) }
  let(:token) { user.create_token('impersonated_by' => 1).tap { user.save!.reload } }
  let(:access_token) { user.build_auth_headers(token.token, token.client)['Access-Token'] }

  describe '#build_impersonation_header' do
    subject { headers.build_impersonation_header }

    context 'when access_token is valid' do

    end

    context 'when the user token does not have the impersonated_by key' do

    end

    context 'when access_token is not valid' do

    end

    context 'when user does not exist' do

    end
  end
end
