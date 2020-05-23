describe UserPresenter do
  describe '#full_name' do
    subject { UserPresenter.new(user).full_name }

    context 'when user has a first_name' do
      let(:user) { build(:user, first_name: 'John', last_name: 'Doe') }

      it 'returns the correct name' do
        expect(subject).to eq('John Doe')
      end
    end

    context 'when user does not have a first_name' do
      let(:user) { build(:user, last_name: 'Doe', username: 'john_doe') }

      it 'returns the username' do
        expect(subject).to eq('john_doe')
      end
    end
  end
end
