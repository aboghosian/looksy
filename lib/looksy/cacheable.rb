module Looksy
  module Cacheable

    def self.included(base)
      base.extend(ClassMethods)

      base.class_eval do
        cattr_accessor :cache_key, :cache_options

        self.cache_key = [self.name, 'all'].join('/')
        self.cache_options = {}
      end
    end

    module ClassMethods
      def fetch_all
        lookup.all
      end

      def fetch_by_id(id)
        lookup.find_by_id(id)
      end

      def method_missing(method, *args, &block)
        if method.match(/^fetch/)
          method = method.to_s.gsub(/^fetch/, 'find')
          lookup.send(method, *args, &block)
        else
          super
        end
      end

      def lookup
        @lookup ||= begin
          cache = if defined?(Rails)
            Rails.cache
          else
            Looksy::NullCache.new
          end

          Looksy::Lookup.new(self, cache)
        end
      end
    end
  end
end