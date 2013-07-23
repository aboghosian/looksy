module Looksy
  module Cache
    class Memory
      def initialize
        @data = {}
      end

      def fetch(key, options = {}, &block)
        unless @data[key]
          @data[key] = block.call if block_given?
        end

        @data[key]
      end

      def has_key?(key)
        true unless @data[key].nil?
      end

      def clear
        @data = {}
      end
    end
  end
end