describe UserPolicy do
  subject { described_class }

  permissions :update? do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'denies access if user is not the same' do
      expect(subject).not_to permit(user1, user2)
    end

    it 'allow access if user is the same' do
      expect(subject).to permit(user1, user1)
    end
  end
end
