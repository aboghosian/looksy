module Looksy
  module Cacheable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def cache_key
        @cache_key ||= [self.name.downcase, 'all'].join('/')
      end

      def cache_key=(key)
        @cache_key = key
      end

      def cache_options
        @cache_options ||= {}
      end

      def cache_options=(options = {})
        @cache_options = options
      end

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

      private

      def lookup
        @lookup ||= Looksy::Lookup.new(self, defined?(Rails) ? Rails.cache : Looksy::NullCache.new)
      end
    end
  end
end