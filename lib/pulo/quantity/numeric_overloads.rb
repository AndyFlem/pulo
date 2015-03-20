# encoding: utf-8

#Cos, Sin and Tan of angles
module Math
  class << self
    alias :old_cos :cos
    def cos(angle)
      if angle.is_a?(Pulo::Angle)
        Pulo::Dimensionless.n(self.old_cos(angle.radians.value))
      else
        self.old_cos(angle)
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
    alias :old_tan :tan
    def tan(angle)
      if angle.is_a?(Pulo::Angle)
        Pulo::Dimensionless.n(self.old_tan(angle.radians.value))
      else
        self.old_tan(angle)
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

#Multiplication is a straight forward reversal for Quantity * Scalar
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
