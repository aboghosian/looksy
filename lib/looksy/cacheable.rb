module Looksy
  module Cacheable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def cache_store
        @cache_store ||= defined?(Rails) ? Rails.cache : Looksy::NullCache.new
      end

      def cache_store=(store)
        @cache_store = store
      end

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
        repository.all
      end

      def fetch_first
        repository.first
      end

      def fetch_last
        repository.last
      end

      def fetch_by_id(id)
        repository.find_by_id(id)
      end

      def method_missing(method, *args, &block)
        if method.match(/^fetch/)
          method = method.to_s.gsub(/^fetch/, 'find')
          repository.send(method, *args, &block)
        else
          super
        end
      end

      private

      def repository
        @repository ||= Looksy::Repository.new(self, cache_store)
      end
    end
  end
end