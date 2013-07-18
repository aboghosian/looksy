require "spec_helper"
require "support/record"

describe Looksy::Cacheable do
  let(:klass) { Record }

  describe '.cache_store' do
    after { klass.cache_store = nil }

    context 'when not set' do
      context 'when using Rails' do
        it 'returns the cache store from Rails'
      end

      context 'when not using Rails' do
        it 'returns the default cache store' do
          klass.cache_store.should be_a(Looksy::NullCache)
        end
      end
    end

    context 'when set' do
      let(:store) { TestCacheStore.new }

      it 'returns the correct cache store' do
        klass.cache_store = store
        klass.cache_store.should eql(store)
      end
    end
  end

  describe '.cache_key' do
    after { klass.cache_key = nil }

    context 'when not set' do
      it 'returns the default cache key' do
        klass.cache_key.should eql('record/all')
      end
    end

    context 'when set' do
      it 'returns the correct cache key' do
        klass.cache_key = 'MyKey'
        klass.cache_key.should eql('MyKey')
      end
    end
  end

  describe '.cache_options' do
    after { klass.cache_options = nil }

    context 'when not set' do
      it 'returns the default cache options' do
        klass.cache_options.should eql({})
      end
    end

    context 'when set' do
      it 'returns the correct cache options' do
        klass.cache_options = { expires_in: 30 }
        klass.cache_options.should have_key(:expires_in)
      end
    end
  end

  describe '.fetch_all' do
    it 'returns all of the records' do
      klass.fetch_all.should eql(klass.all)
    end
  end

  describe '.fetch_first' do
    it 'returns the first record' do
      klass.fetch_first.should eql(klass.first)
    end
  end

  describe '.fetch_last' do
    it 'returns the last record' do
      klass.fetch_last.should eql(klass.last)
    end
  end

  describe '.fetch_by_id' do
    let(:record) { klass.last }

    it 'returns the correct record' do
      klass.fetch_by_id(record.id).should eql(record)
    end
  end

  describe '.method_missing' do
    context 'when method starts with fetch' do
      it 'returns matching records' do
        records = klass.fetch_by_type('Developer')
        records.count.should eql(3)
      end
    end

    context 'when method does not start with fetch' do
      before { klass.should_receive(:method_missing) }

      it 'calls method missing on the host' do
        klass.non_existent_method
      end
    end
  end
end