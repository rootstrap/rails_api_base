# frozen_string_literal: true

describe Impersonation::Verifier do
  let(:verifier) { described_class.new }

  describe '#sign!' do
    subject { verifier.sign!(data) }

    context 'when data is present' do
      let(:data) { 1 }

      # expect to be an encrypted response
      # expect to an url safe
    end
  end

  describe '#verify!' do
    subject { verifier.verify!(encoded_data) }

    context 'when encoded_data is valid' do
      let(:encoded_data) { verifier.sign!('test') }

      # it decodes the encoded_data
    end
  end
end
