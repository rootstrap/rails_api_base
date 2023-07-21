# frozen_string_literal: true

describe Admin::AdminUserPolicy do
  subject(:policy) { described_class }

  permissions :update?, :index?, :show?, :create?, :new?, :edit?, :destroy? do
    let(:admin) { create(:admin_user) }

    it 'allows access' do
      expect(policy).to permit(admin, admin)
    end
  end
end
