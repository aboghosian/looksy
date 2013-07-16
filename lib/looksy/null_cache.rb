module Looksy
  class NullCache
    def fetch(key, options = {}, &block)
      block.call
    end
  end
end