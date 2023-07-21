# frozen_string_literal: true

describe Admin::UserPolicy do
  subject(:policy) { described_class }

  permissions :update?, :index?, :show?, :create?, :new?, :edit?, :destroy? do
    let(:admin) { create(:admin_user) }
    let(:user)  { create(:user) }

    it 'allow access' do
      expect(policy).to permit(admin, user)
    end
  end
end
