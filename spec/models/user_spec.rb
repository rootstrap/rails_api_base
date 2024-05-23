# frozen_string_literal: true

# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  allow_password_change  :boolean          default(FALSE)
#  remember_created_at    :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  name                   :string
#  nickname               :string
#  image                  :string
#  email                  :string
#  tokens                 :json
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
# rubocop:enable Layout/LineLength

describe User do
  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider) }

    context 'when was created with regular login' do
      subject { build(:user) }

      it { is_expected.to validate_uniqueness_of(:email).case_insensitive.scoped_to(:provider) }
      it { is_expected.to validate_presence_of(:email) }
    end
  end

  context 'when was created with regular login' do
    let!(:user) { create(:user) }
    let(:full_name) { user.full_name }

    it 'returns the correct name' do
      expect(full_name).to eq(user.username)
    end
  end

  context 'when user has first_name' do
    let!(:user) { create(:user, first_name: 'John', last_name: 'Doe') }

    it 'returns the correct name' do
      expect(user.full_name).to eq('John Doe')
    end
  end

  describe '.from_social_provider' do
    context 'when user does not exists' do
      let(:params) { attributes_for(:user) }

      it 'creates the user' do
        expect {
          described_class.from_social_provider('provider', params)
        }.to change(described_class, :count).by(1)
      end
    end

    context 'when the user exists' do
      let!(:user)  { create(:user, provider: 'provider', uid: 'user@example.com') }
      let(:params) { attributes_for(:user).merge('id' => 'user@example.com') }

      it 'returns the given user' do
        expect(described_class.from_social_provider('provider', params))
          .to eq(user)
      end
    end
  end
end
