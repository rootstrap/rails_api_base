describe ApplicationPolicy do
  subject { described_class }

  permissions :update?, :index?, :show?, :create?, :new?, :edit?, :destroy? do
    let(:user) { create(:user) }

    it 'denies access' do
      expect(subject).not_to permit
    end
  end
end
