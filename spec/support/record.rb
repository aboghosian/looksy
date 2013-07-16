class Record < Struct.new(:id, :name, :type)
  def attributes
    {
      "id" => id,
      "name" => name,
      "type" => type
    }
  end
end