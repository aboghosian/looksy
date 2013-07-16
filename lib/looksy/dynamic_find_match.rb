module Looksy
  class DynamicFindMatch < Struct.new(:finder, :attributes)
    def self.match(method)
      finder = :find

      case method.to_s
      when /^find_(all_)?by_([_a-zA-Z]\w*)$/
        finder = :select if $1 == 'all_'
        attributes = $2
      else
        return nil
      end

      new(finder, attributes.split('_and_'))
    end
  end
end