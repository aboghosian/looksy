module Looksy
  class Lookup
    def initialize(klass, cache)
      @klass = klass
      @cache = cache
    end

    def all
      @cache.fetch(@klass.cache_key, @klass.cache_options) { @klass.all }
    end

    def first
      all.first
    end

    def last
      all.last
    end

    def find_by_id(id)
      all.find { |record| record.id == id.to_i }
    end

    def method_missing(method, *args, &block)
      if match = Looksy::DynamicFindMatch.match(method)
        super unless all_attributes_exist?(match.attributes)

        attributes = extract_attributes(match.attributes) do |attribute|
          args[match.attributes.index(attribute)]
        end

        result = all.send(match.finder) do |record|
          record_attributes = extract_attributes(match.attributes) do |attribute|
            record.send(attribute)
          end

          record_attributes == attributes
        end

        match.extractor ? result.send(match.extractor) : result
      else
        super
      end
    end

    private

    def all_attributes_exist?(attributes)
      (attributes - klass_attributes).empty?
    end

    def klass_attributes
      @klass_attributes ||= @klass.new.attributes.keys
    end

    def extract_attributes(attributes, &block)
      Hash[attributes.map { |a| [a, sanitize_attribute_value(block.call(a))] }]
    end

    def sanitize_attribute_value(value)
      case value
      when Symbol, String
        value.to_s.downcase
      else
        value
      end
    end
  end
end