# frozen_string_literal: true

describe AdminUserPolicy do
  subject(:policy) { described_class }

  permissions :update?, :index?, :show?, :create?, :new?, :edit?, :destroy? do
    let(:admin) { create(:admin_user) }
    let(:user)  { create(:user) }

    it 'denies access' do
      expect(policy).not_to permit(user, admin)
    end
  end
end
