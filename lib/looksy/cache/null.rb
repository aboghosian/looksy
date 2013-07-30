module Looksy
  module Cache
    class Null
      def fetch(key, options = {}, &block)
        block.call if block_given?
      end
    end
  end
end