# frozen_string_literal: true

describe Impersonation::Verifier do
  let(:verifier) { described_class.new }

  describe '#sign!' do
    subject { verifier.sign!(data) }

    context 'when data is present' do
      let(:data) { 1 }

      it 'returns a Base64.urlsafe_encode64 string' do
        expect(Base64.decode64(subject)).to start_with("{\"_rails\":{\"data\":#{data},\"exp\"")
      end
    end
  end

  describe '#verify!' do
    subject { verifier.verify!(encoded_data) }

    context 'when encoded_data is valid' do
      let(:encoded_data) { verifier.sign!('test') }

      it 'returns the decoded data' do
        expect(subject).to eq 'test'
      end
    end
  end
end
