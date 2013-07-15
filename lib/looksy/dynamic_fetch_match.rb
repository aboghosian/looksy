module Looksy
  class DynamicFetchMatch < Struct.new(:finder, :attributes)
    def self.match(method)
      finder = :find

      case method.to_s
      when /^fetch_(all_)?by_([_a-zA-Z]\w*)$/
        finder = :select if $1 == 'all_'
        attributes = $2
      else
        return nil
      end

      new(finder, attributes.split('_and_'))
    end
  end
end