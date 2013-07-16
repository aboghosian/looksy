class Record < Struct.new(:id, :name, :type)
  extend Looksy::Cacheable

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

  def self.second
    all[1]
  end

  def self.third
    all[2]
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