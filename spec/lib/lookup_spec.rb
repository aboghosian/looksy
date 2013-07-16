require "spec_helper"

class Record < Struct.new(:id, :name, :type)
  def attributes
    {
      "id" => id,
      "name" => name,
      "type" => type
    }
  end
end

describe Looksy::Lookup do
  let(:first_record) { Record.new(1, 'Artin', 'Developer') }
  let(:second_record) { Record.new(2, 'Paul', 'Developer') }
  let(:third_record) { Record.new(3, 'George', 'QA') }
  let(:fourth_record) { Record.new(4, 'Artin', 'Developer') }
  let(:records) { [first_record, second_record, third_record, fourth_record] }
  let(:klass) { Record }
  let(:cache) { Looksy::NullCache.new }
  let(:lookup) { Looksy::Lookup.new(klass, cache) }
  
  before do
    klass.stub(:cache_key).and_return('key')
    klass.stub(:cache_options).and_return({})
    klass.stub(:all).and_return(records)
  end

  describe '#all' do
    it 'retrieves all records' do
      lookup.all.should eql(records)
    end
  end

  describe '#find_by_id' do
    it 'retrieves record matching id' do
      lookup.find_by_id(2).should eql(second_record)
    end
  end

  describe '#method_missing' do
    context 'when finding multiple records' do
      context 'when finding by single attribute' do
        it 'returns the matching records' do
          result = lookup.find_all_by_type('Developer')
          result.should include(first_record)
          result.should include(second_record)
          result.should include(fourth_record)
        end
      end

      context 'when finding by multiple attributes' do
        it 'returns the matching records' do
          result = lookup.find_all_by_name_and_type('Artin', 'Developer')
          result.should include(first_record)
          result.should include(fourth_record)
        end
      end
    end

    context 'when finding single record' do
      context 'when finding by single attribute' do
        it 'returns the matching receord' do
          lookup.find_by_name('Artin').should eql(first_record)
        end
      end

      context 'when finding by multiple attributes' do
        it 'returns the matching record' do
          lookup.find_by_name_and_type('George', 'QA').should eql(third_record)
        end
      end
    end
  end
end