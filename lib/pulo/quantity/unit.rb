# encoding: utf-8

class Unit
  attr_reader :name, :plural, :abbreviation
  def initialize name, plural, abbreviation
    case plural
      when :s
        plural=name.to_s + 's'
      when :sf
        plural=name.to_s.sub(/(?<=.)_{1}/,'s_')
      else
        plural=plural.to_s
    end
    @name,@plural,@abbreviation=name,plural,abbreviation
  end
  def to_s
    name.to_s + ', ' + plural + ', ' + abbreviation
  end
end
class SI_Unit < Unit
  attr_reader :scale
  def initialize name, plural, abbreviation,scale
    super name, plural, abbreviation
    @scale=scale
  end
  def is_si?; true; end
end
class NonSI_Unit < Unit
  attr_reader :si_convert_unit, :si_convert_factor
  def initialize name, plural, abbreviation,si_convert_unit, si_convert_factor
    super name, plural, abbreviation
    @si_convert_unit,@si_convert_factor=si_convert_unit,si_convert_factor
  end
  def is_si?; false; end
end