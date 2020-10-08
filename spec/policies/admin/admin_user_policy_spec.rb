describe Admin::AdminUserPolicy do
  subject { described_class }

  permissions :update?, :index?, :show?, :create?, :new?, :edit?, :destroy? do
    let(:admin) { create(:admin_user) }

    it 'allows access' do
      expect(subject).to permit(admin, admin)
    end
  end
end
