require "spec_helper"

describe Looksy::Cache::Memory do
  let(:cache) { Looksy::Cache::Memory.new }

  after { cache.clear }

  describe '#fetch' do
    context 'when passing block' do
      context 'when key exists' do
        before { cache.fetch('block_with_key') { 'result' } }

        it 'returns the correct data' do
          cache.fetch('block_with_key').should eql('result')
        end
      end

      context 'when key does not exist' do
        it 'stores the data' do
          cache.fetch('block_without_key') { 'result' }
          cache.should have_key('block_without_key')
        end

        it 'returns the correct data' do
          cache.fetch('block_without_key') { 'result' }
          cache.fetch('block_without_key').should eql('result')
        end
      end
    end

    context 'when not passing block' do
      context 'when key exists' do
        before { cache.fetch('key_without_block') { 'result' } }

        it 'returns the correct data' do
          cache.fetch('key_without_block').should eql('result')
        end
      end

      context 'when key does not exist' do
        it 'returns nil' do
          cache.fetch('no_key_without_block').should be_nil
        end
      end
    end
  end

  describe '#clear' do
    before { cache.fetch('clear_data') { 'result'} }

    it 'clears the stored data' do
      cache.clear
      cache.should_not have_key('clear_data')
    end
  end

  describe '#has_key?' do
    context 'when has key' do
      before { cache.fetch('has_key') { 'result' } }

      it 'returns true' do
        cache.should have_key('has_key')
      end
    end

    context 'when does not have key' do
      it 'returns false' do
        cache.should_not have_key('dont_have_key')
      end
    end
  end
end