# encoding: utf-8

#Cos, Sin and Tan of angles
class Numeric
  def clamp(min, max)
    if self < min
      min
    else
      self > max ? max : self
    end
  end
end

module Math
  class << self
    alias :old_sqrt :sqrt
    def sqrt(val)
      if val.is_a?(Pulo::Quantity)
        val.rt(2)
      else
        self.old_sqrt(val)
      end
    end

    alias :old_cos :cos
    def cos(angle)
      if angle.is_a?(Pulo::Angle)
        Pulo::Dimensionless.n(self.old_cos(angle.radians.value))
      else
        self.old_cos(angle)
      end
    end

    alias :old_acos :acos
    def acos(dimless)
      if dimless.is_a?(Pulo::Dimensionless)
        Pulo::Angle.radians(self.old_acos(dimless.n.value.clamp(-1,1)))
      else
        self.old_acos(dimless)
      end
    end

    alias :old_sin :sin
    def sin(angle)
      if angle.is_a?(Pulo::Angle)
        Pulo::Dimensionless.n(self.old_sin(angle.radians.value))
      else
        self.old_sin(angle)
      end
    end

    alias :old_asin :asin
    def asin(dimless)
      if dimless.is_a?(Pulo::Dimensionless)
        Pulo::Angle.radians(self.old_asin(dimless.n.value.clamp(-1,1)))
      else
        self.old_asin(dimless)
      end
    end

    alias :old_tan :tan
    def tan(angle)
      if angle.is_a?(Pulo::Angle)
        Pulo::Dimensionless.n(self.old_tan(angle.radians.value))
      else
        self.old_tan(angle)
      end
    end

    alias :old_atan :atan
    def atan(dimless)
      if dimless.is_a?(Pulo::Dimensionless)
        Pulo::Angle.radians(self.old_tan(dimless.n.value))
      else
        self.old_atan(dimless)
      end
    end

  end
end

#Add and subtract work for Dimensionless
class BigDecimal
  alias :old_minus :-
  def -(other)
    if other.is_a?(Pulo::Dimensionless)
      Pulo::Dimensionless.new(1-other.to_base_unit.value)
    else
      self.old_minus(other)
    end
  end
end

class Bignum
  alias :old_minus :-
  def -(other)
    if other.is_a?(Pulo::Dimensionless)
      Pulo::Dimensionless.new(1-other.to_base_unit.value)
    else
      self.old_minus(other)
    end
  end
end

class Fixnum
  alias :old_minus :-
  def -(other)
    if other.is_a?(Pulo::Dimensionless)
      Pulo::Dimensionless.new(1-other.to_base_unit.value)
    else
      self.old_minus(other)
    end
  end
end

class Float
  alias :old_minus :-
  def -(other)
    if other.is_a?(Pulo::Dimensionless)
      Pulo::Dimensionless.new(1-other.to_base_unit.value)
    else
      self.old_minus(other)
    end
  end
end

class BigDecimal
  alias :old_plus :+
  def +(other)
    if other.is_a?(Pulo::Dimensionless)
      Pulo::Dimensionless.new(1+other.to_base_unit.value)
    else
      self.old_plus(other)
    end
  end
end

class Bignum
  alias :old_plus :+
  def +(other)
    if other.is_a?(Pulo::Dimensionless)
      Pulo::Dimensionless.new(1+other.to_base_unit.value)
    else
      self.old_plus(other)
    end
  end
end

class Fixnum
  alias :old_plus :+
  def +(other)
    if other.is_a?(Pulo::Dimensionless)
      Pulo::Dimensionless.new(1+other.to_base_unit.value)
    else
      self.old_plus(other)
    end
  end
end

class Float
  alias :old_plus :+
  def +(other)
    if other.is_a?(Pulo::Dimensionless)
      Pulo::Dimensionless.new(1+other.to_base_unit.value)
    else
      self.old_plus(other)
    end
  end
end

#Division (Scalar/Quantity) gives (1/Quantity) * Scalar
class BigDecimal
  alias :old_div :/
  def /(other)
    if other.is_a?(Pulo::Quantity)
      other.inverse*self
    else
      self.old_div(other)
    end
  end
end

class Bignum
  alias :old_div :/
  def /(other)
    if other.is_a?(Pulo::Quantity)
      other.inverse*self
    else
      self.old_div(other)
    end
  end
end

class Fixnum
  alias :old_div :/
  def /(other)
    if other.is_a?(Pulo::Quantity)
      other.inverse*self
    else
      self.old_div(other)
    end
  end
end

class Float
  alias :old_div :/
  def /(other)
    if other.is_a?(Pulo::Quantity)
      other.inverse*self
    else
      self.old_div(other)
    end
  end
end

#Multiplication is a reversal for Quantity * Scalar
class BigDecimal
  alias :old_times :*
  def *(other)
    if other.is_a?(Pulo::Quantity)
      other*self
    else
      self.old_times(other)
    end
  end
end

class Fixnum
  alias :old_times :*
  def *(other)
    if other.is_a?(Pulo::Quantity)
      other*self
    else
      self.old_times(other)
    end
  end
end

class Float
  alias :old_times :*
  def *(other)
    if other.is_a?(Pulo::Quantity)
      other*self
    else
      self.old_times(other)
    end
  end
end

class Bignum
  alias :old_times :*
  def *(other)
    if other.is_a?(Pulo::Quantity)
      other*self
    else
      self.old_times(other)
    end
  end
end
