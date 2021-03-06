require "spec_helper"
require "support/record"

describe Looksy::Repository do
  let(:klass) { Record }
  let(:cache) { Looksy::Cache::Memory.new }
  let(:lookup) { Looksy::Repository.new(klass, cache) }
  
  describe '#all' do
    it 'retrieves all records' do
      lookup.all.should eql(klass.all)
    end
  end

  describe '#first' do
    it 'retrieves the first record' do
      lookup.first.should eql(klass.first)
    end
  end

  describe '#last' do
    it 'retrieves the last record' do
      lookup.last.should eql(klass.last)
    end
  end

  describe '#find_by_id' do
    let(:record) { lookup.find_by_id(2) }

    it 'retrieves record matching id' do
      record.id.should eql(2)
    end
  end

  describe '#method_missing' do
    context 'when finding multiple records' do
      context 'when finding by single attribute' do
        let(:records) { lookup.find_all_by_type('Developer') }

        it 'returns the matching records' do
          records.each { |record| record.type.should eql('Developer') }
        end
      end

      context 'when finding by multiple attributes' do
        let(:records) { lookup.find_all_by_name_and_type('Artin', 'Developer') }

        it 'returns the matching records' do
          records.each do |record|
            record.type.should eql('Developer')
            record.name.should eql('Artin')
          end
        end
      end
    end

    context 'when finding single record' do
      context 'when finding by single attribute' do
        let(:record) { lookup.find_by_name('Artin') }

        it 'returns the matching record' do
          record.name.should eql('Artin')
        end
      end

      context 'when finding by multiple attributes' do
        let(:record) { lookup.find_by_name_and_type('George', 'QA') }

        it 'returns the matching record' do
          record.name.should eql('George')
          record.type.should eql('QA')
        end
      end
    end

    context 'when finding last matching record' do
      let(:match) { Record.all.select { |r| r.name == 'Artin'}.last }
      let(:record) { lookup.find_last_by_name('Artin') }

      it 'returns the matching record' do
        record.should eql(match)
      end
    end
  end
end