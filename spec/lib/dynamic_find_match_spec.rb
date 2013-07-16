require "spec_helper"

describe Looksy::DynamicFindMatch do
  describe '.match' do
    context 'when method matches' do
      context 'when method has one attribute' do
        let(:method) { :find_by_this }
        let(:match) { Looksy::DynamicFindMatch.match(method) }

        it 'returns the correct attributes' do
          match.attributes.should eql(['this'])
        end
      end

      context 'when method has multiple attributes' do
        let(:method) { :find_by_this_and_that }
        let(:match) { Looksy::DynamicFindMatch.match(method) }

        it 'returns the correct attributes' do
          match.attributes.should eql(['this', 'that'])
        end
      end

      context 'when method finds one record' do
        let(:method) { :find_by_this }
        let(:match) { Looksy::DynamicFindMatch.match(method) }

        it 'returns the correct finder' do
          match.finder.should eql(:find)
        end
      end

      context 'when method finds multiple records' do
        let(:method) { :find_all_by_this }
        let(:match) { Looksy::DynamicFindMatch.match(method) }

        it 'returns the correct finder' do
          match.finder.should eql(:select)
        end
      end
    end

    context 'when method does not match' do
      let(:method) { :find_does_not_match }
      let(:match) { Looksy::DynamicFindMatch.match(method) }

      it 'returns nil' do
        match.should be_nil
      end
    end
  end
end