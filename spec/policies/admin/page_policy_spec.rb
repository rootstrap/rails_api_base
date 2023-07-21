# frozen_string_literal: true

describe Admin::PagePolicy do
  subject(:policy) { described_class }

  permissions :show? do
    let(:user) { create(:user) }
    let(:record) { instance_double('DashboardRecord', name: 'Dashboard') }

    it 'allow access if record.name is Dashboard' do
      expect(policy).to permit(user, record)
    end

    context 'when the record name is distinct to Dashboard' do
      let(:record) { instance_double('NoneDashboardRecord', name: 'not-valid') }

      it 'denies access' do
        expect(policy).not_to permit(user, record)
      end
    end
  end
end
