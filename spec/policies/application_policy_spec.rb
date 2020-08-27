describe ApplicationPolicy do
  subject { described_class }

  permissions :update?, :index?, :show?, :create?, :new?, :edit?, :destroy? do
    context 'when is an user' do
      let!(:user) { create(:user) }

      it 'denies access' do
        expect(subject).not_to permit(user, user)
      end
    end

    context 'when is an admin' do
      let!(:admin) { create(:admin_user) }

      it 'permits access' do
        expect(subject).to permit(admin, admin)
      end
    end
  end

  describe 'scope' do
    let(:user) { create(:user) }
    let(:mock_model) { OpenStruct.new(all: true) }
    subject { ApplicationPolicy::Scope.new(user, mock_model).resolve }

    it 'shows all models' do
      expect(subject).to be(true)
    end
  end
end
