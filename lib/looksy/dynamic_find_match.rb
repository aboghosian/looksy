module Looksy
  class DynamicFindMatch < Struct.new(:finder, :extractor, :attributes)
    def self.match(method)
      finder = :find
      extractor = nil

      case method.to_s
      when /^find_(last_|all_)?by_([_a-zA-Z]\w*)$/
        case $1
        when 'last_'
          finder = :select
          extractor = :last
        when 'all_'
          finder = :select
        end

        attributes = $2
      else
        return nil
      end

      new(finder, extractor, attributes.split('_and_'))
    end
  end
end