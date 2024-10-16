# frozen_string_literal: true

describe Admin::UserPolicy do
  subject { described_class }

  permissions :update?, :index?, :show?, :create?, :new?, :edit?, :destroy? do
    let(:admin) { create(:admin_user) }
    let(:user)  { create(:user) }

    it 'allow access' do
      expect(subject).to permit(admin, user)
    end
  end

  permissions :impersonate? do
    let(:admin) { create(:admin_user) }
    let(:user)  { create(:user) }

    it 'allow access when impersonate_tool is enable' do
      allow(Flipper).to receive(:enabled?).with(:impersonation_tool).and_return(true)

      expect(subject).to permit(admin, user)
    end

    it 'denies access when impersonate_tool is disable' do
      allow(Flipper).to receive(:enabled?).with(:impersonation_tool).and_return(false)

      expect(subject).not_to permit(admin, user)
    end
  end
end
