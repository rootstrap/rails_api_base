RSpec.shared_examples 'there must not be a Set-Cookie in Header' do
  it 'does not return a Set-Cookie Header' do
    subject
    expect(response.headers.keys).not_to include('Set-Cookie')
  end
end
