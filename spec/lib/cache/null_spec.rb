require "spec_helper"

describe Looksy::Cache::Null do
  let(:cache) { Looksy::Cache::Null.new }

  describe '#fetch' do
    context 'when passing block' do
      it 'returns the result of the block' do
        cache.fetch('key') { 'result' }.should eql('result')
      end
    end

    context 'when not passing block' do
      it 'returns nil' do
        cache.fetch('key').should be_nil
      end
    end
  end
end