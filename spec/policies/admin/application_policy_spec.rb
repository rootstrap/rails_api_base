# frozen_string_literal: true

describe Admin::ApplicationPolicy do
  subject { described_class }

  permissions :update?, :index?, :show?, :create?, :new?, :edit?, :destroy? do
    context 'when is an admin user' do
      let(:admin) { build(:admin_user) }

      it 'allows access' do
        expect(subject).to permit(admin, admin)
      end
    end

    context 'when is a user' do
      let(:user) { build(:user) }

      it 'denies access' do
        expect(subject).not_to permit(user, user)
      end
    end
  end

  describe 'scope' do
    subject { Admin::ApplicationPolicy::Scope.new(admin, mock_model).resolve }

    let(:admin) { create(:admin_user) }
    let(:mock_model) { instance_double('MockModel', all: true) }

    it 'shows all models' do
      expect(subject).to be(true)
    end
  end
end
