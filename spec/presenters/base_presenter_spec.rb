describe BasePresenter do
  describe '.wrap_collection' do
    subject { presenter.wrap_collection(records) }

    let(:presenter) do
      Class.new(BasePresenter) do
        delegate_missing_to :record

        def initialize(record)
          @record = record
        end

        private

        attr_reader :record
      end
    end
    let(:record) { Struct.new(:name) }
    let(:records) { (1..3).map { |i| record.new("Record #{i}") } }

    it 'wraps all records inside a presenter' do
      expect(subject).to all(be_a(presenter))
    end

    it 'allows using record method on the presenters' do
      expect(subject).to all(respond_to(:name))
    end
  end
end
