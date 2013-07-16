module Looksy
  module Cacheable
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        def self.cache_key
          @cache_key ||= [self.name.downcase, 'all'].join('/')
        end

        def self.cache_key=(key)
          @cache_key = key
        end

        def self.cache_options
          @cache_options ||= {}
        end

        def self.cache_options=(options = {})
          @cache_options = options
        end

        private

        def self.lookup
          @lookup ||= Looksy::Lookup.new(self, defined?(Rails) ? Rails.cache : Looksy::NullCache.new)
        end
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
    end
  end
end