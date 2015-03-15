class CalcTable
  attr_reader :name
  def initialize(name)
    @name=name
  end

  def row_append(name,&calculation)

  end
end

class CalcRow
  def initialize(name, &calculation)

  end
end