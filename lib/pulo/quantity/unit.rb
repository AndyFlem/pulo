# encoding: utf-8

module Pulo
  class Unit
    attr_reader :name, :plural, :abbreviation
    def initialize(name, plural, abbreviation)
      case plural
        when :s
          plural=name.to_s + 's'
        when :sf
          plural=name.to_s.sub(/(?<=.)_{1}/, 's_')
        else
          plural=plural.to_s
      end
      @name, @plural, @abbreviation=name, plural, abbreviation
    end
    def to_s
      ret=abbreviation.ljust(12,' ') + name.to_s.ljust(30) + plural.ljust(30)
      if self.is_si?
        ret+='*10^' + self.scale.round(2).to_s.ljust(7,' ')
      else
        ret+=self.si_convert_factor.round(4).to_s + ' per ' + self.si_convert_unit.to_s
      end
      ret
    end
  end

  class SI_Unit < Unit
    attr_reader :scale
    def initialize(name, plural, abbreviation, scale)
      super name, plural, abbreviation
      @scale=scale
    end
    def is_si?; true; end
  end

  class NonSI_Unit < Unit
    attr_reader :si_convert_unit, :si_convert_factor
    def initialize(name, plural, abbreviation, si_convert_unit, si_convert_factor)
      super name, plural, abbreviation
      @si_convert_unit, @si_convert_factor=si_convert_unit, si_convert_factor
    end
    def is_si?; false; end
  end
end