# frozen_string_literal: true

describe 'POST api/v1/impersonations' do
  subject { post impersonations_path, params:, as: :json }

  context 'with valid params' do
    let(:params) { { auth: } }
    let(:user) { create(:user) }
    let(:auth) { Impersonation::Verifier.new.sign!(user_id: user.id, admin_user_id: 1) }
  end

  context 'with invalid params' do
    context 'when auth is nil' do

    end

    context 'when user_id does not exist' do

    end
  end
end
