describe UserDecorator do
  let(:user) { create(:user) }
  let(:decorated_user) { user.decorate }

  it 'returns same email' do
    expect(decorated_user.email).to eq(user.email)
  end
end
