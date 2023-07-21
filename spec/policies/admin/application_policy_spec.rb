# frozen_string_literal: true

describe Admin::ApplicationPolicy do
  subject(:policy) { described_class }

  permissions :update?, :index?, :show?, :create?, :new?, :edit?, :destroy? do
    context 'when is an admin user' do
      let(:admin) { build(:admin_user) }

      it 'allows access' do
        expect(policy).to permit(admin, admin)
      end
    end

    context 'when is a user' do
      let(:user) { build(:user) }

      it 'denies access' do
        expect(policy).not_to permit(user, user)
      end
    end
  end

  describe 'scope' do
    subject(:scope) { ApplicationPolicy::Scope.new(admin, mock_model).resolve }

    let(:admin) { create(:admin_user) }
    let(:mock_model) { instance_double('MockModel', all: true) }

    it 'shows all models' do
      expect(scope).to be(true)
    end
  end
end
