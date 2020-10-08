describe Admin::PagePolicy do
  subject { described_class }

  permissions :show? do
    let(:user) { create(:user) }
    let(:record) { double('DashboardRecord', name: 'Dashboard') }

    it 'allow access if record.name is Dashboard' do
      expect(subject).to permit(user, record)
    end

    context 'when the record name is distinct to Dashboard' do
      let(:record) { double('NoneDashboardRecord', name: 'not-valid') }

      it 'denies access' do
        expect(subject).not_to permit(user, record)
      end
    end
  end
end
