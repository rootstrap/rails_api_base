# frozen_string_literal: true

describe Impersonation::Headers do
  let(:user) { create(:user) }

  describe '#build_impersonation_header' do
    subject { described_class.new(user).build_impersonation_header }

    context 'when the user has not been impersonated' do
      before do
        user.impersonated_by = nil
      end

      it 'returns an empty hash' do
        expect(subject).to eq({})
      end
    end

    context 'when the user has been impersonated' do
      before do
        user.impersonated_by = 100
      end

      it 'returns the impersonated header' do
        expect(subject).to eq({ 'impersonated' => true })
      end
    end
  end
end
