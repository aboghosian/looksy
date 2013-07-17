class Record < Struct.new(:id, :name, :type)
  include Looksy::Cacheable

  def self.all
    @all ||= [
      new(1, 'Artin', 'Developer'),
      new(2, 'Paul', 'Developer'),
      new(3, 'George', 'QA'),
      new(4, 'Artin', 'Developer')
    ]
  end

  def self.first
    all.first
  end

  def self.last
    all.last
  end

  def attributes
    {
      "id" => id,
      "name" => name,
      "type" => type
    }
  end
end

class TestCacheStore
  def fetch(key, options)
    nil
  end
end