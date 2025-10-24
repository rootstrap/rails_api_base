# frozen_string_literal: true

describe Ransackable do
  let(:fake_class) do
    Class.new do
      include Ransackable

      const_set(:Ransackers, Data.define(:keys))
      const_set(:Associations, Data.define(:name))

      const_set(:RANSACK_ATTRIBUTES, [:attr_one])
      const_set(:RANSACK_ASSOCIATIONS, [:assoc_one])

      def self.column_names
        %i[attr_one attr_two]
      end

      def self.ransackers
        self::Ransackers.new([:attr_three])
      end

      def self.reflect_on_all_associations
        [self::Associations.new(:assoc_one), self::Associations.new(:assoc_two)]
      end
    end
  end

  describe '.ransackable_attributes' do
    subject { fake_class.ransackable_attributes(auth_object) }

    context 'when is admin' do
      let(:auth_object) { :admin }

      it 'returns all attributes' do
        expect(subject).to eq(%i[attr_one attr_two attr_three])
      end
    end

    context 'when is not admin' do
      let(:auth_object) { :user }

      it 'returns safelisted attributes' do
        expect(subject).to eq([:attr_one])
      end
    end
  end

  describe '.ransackable_associations' do
    subject { fake_class.ransackable_associations(auth_object) }

    context 'when is admin' do
      let(:auth_object) { :admin }

      it 'returns all associations' do
        expect(subject).to eq(%w[assoc_one assoc_two])
      end
    end

    context 'when is not admin' do
      let(:auth_object) { :user }

      it 'returns safelisted associations' do
        expect(subject).to eq([:assoc_one])
      end
    end
  end
end
