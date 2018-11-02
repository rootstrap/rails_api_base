require 'spec_helper'

describe Base64Attach do
  let!(:data) { 'aGVsbG8=' }

  context 'when the data is a base64 string' do
    it 'returns the decoded data as an IO' do
      attachment = Base64Attach.attachment_from_base64(data: data)

      expect(attachment[:io].string).to eq('hello')
    end
  end

  context 'when the data has headers' do
    let!(:data_with_headers) { "data:image/png;base64,#{data}" }

    it 'strips them returning the same result' do
      attachment = Base64Attach.attachment_from_base64(data: data_with_headers)

      expect(attachment[:io].string).to eq('hello')
    end
  end
end
