# encoding: utf-8

module Pulo
  class Quantity
  include Comparable
  #=====================================
  #Quantity: Class variables and methods - Child Quantities
  #=====================================
  class << self
    def units; @units ||={}; end
    def si_unit_scales; @si_unit_scales ||={};end
    def base_unit; @base_unit ;end
    def base_unit=(value); @base_unit=value; end
    def dimensions; @dimensions;end
    def dimensions=(value); @dimensions=value; end

    def synonyms; @synonyms ||=[]; end

    def best_si_unit_for_pair quan1,quan2
      av=(quan1.base_unit_scale+quan2.base_unit_scale)/2
      best_si_unit av
    end
    def best_si_unit scale
      @si_unit_scales.min_by do |unit|
        (scale-unit[0]).abs
      end[1]
    end
    def to_s
      ret=''
      ret+="#{self.name.split(/::/)[1]}"
      ret+=" #{self.synonyms.to_s}\n"
      ret+="Dimensions: #{self.dimensions.to_s}\n"
      ret+=self.units.inject('') {|mm,unt| mm+='     ' + unt[1].to_s + "\n"}
    end
    def conversions_list
      obj=self.new(1)
      self.units.map do |unt|
          obj.send(unt[0]).to_s
      end
    end
    def quantity_name
      self.name.split('::')[1]
    end
  end

  #=====================================
  #Instance variables and methods - Child Quantities
  #=====================================
  def value
    @value
  end
  def value=(val)
    @value=val
  end
  def unit
    @unit
  end
  def unit=(val)
    @unit=val
  end

  def initialize value=nil,unit=nil
    value=1.0 if value.nil?
    if unit
      if unit.is_a?(Symbol)
        self.unit=self.class.units[unit]
      else
        self.unit=unit
      end
    else
      self.unit=self.class.base_unit
    end
    self.value=Float(value) unless self.value.is_a?(Float)
    self
  end

  def to_s(precision=nil)
    "#{self.class.quantity_name + ': ' unless $no_quantity_names}#{NumberToRoundedConverter.convert(@value,precision)} #{@unit.abbreviation}"
  end

  def to; self; end
  def in; self; end

  def inverse
    Dimensionless.new/self
  end
  def +(other)
    case
      when other.is_a?(Numeric)
        self.class.new self.value+other,self.unit
      when other.class.dimensions==self.class.dimensions
        if self.unit==other.unit
          self.class.new self.value+other.value,self.unit
        else
          self.class.new self.value+other.send(self.unit.name).value,self.unit
        end
      else
        raise  QuantitiesException.new("Cannot add a #{other.class.name} to a #{self.class.name}")
    end
  end
  def -(other)
    case
      when other.is_a?(Numeric)
        self.class.new self.value-other,self.unit
      when other.class.dimensions==self.class.dimensions
        if self.unit==other.unit
          self.class.new self.value-other.value,self.unit
        else
          self.class.new self.value-other.send(self.unit.name).value,self.unit
        end
      else
        raise  QuantitiesException.new("Cannot minus a #{other.class.name} from a #{self.class.name}")
    end
  end
  def *(other)
    case
      when other.is_a?(Numeric)
        obj=self.class.new self.value*other,self.unit
      when other.is_a?(Quantity)
        new_dims=self.class.dimensions+other.class.dimensions

        #get both quantities to their equivalent SI if needed
        q1=self; q1=q1.to_si unless q1.is_si?
        q2=other; q2=q2.to_si unless q2.is_si?

        target_scale=q1.unit.scale+q2.unit.scale
        target_value=q1.value*q2.value
        existing_or_new_quantity new_dims,target_scale,target_value
      else
        raise  QuantitiesException.new("Cannot multiply a #{other.class.name} and a #{self.class.name}")
    end
  end
  def /(other)
    case
      when other.is_a?(Numeric)
        obj=self.class.new self.value/other,self.unit
      when other.is_a?(Quantity)
        new_dims=self.class.dimensions-other.class.dimensions

        q1=self; q1=q1.to_si unless q1.is_si?
        q2=other; q2=q2.to_si unless q2.is_si?

        target_scale=q1.unit.scale-q2.unit.scale
        target_value=q1.value/q2.value
        existing_or_new_quantity new_dims,target_scale,target_value
      else
        raise  QuantitiesException.new("Cannot divide a #{self.class.name} by a #{other.class.name}")
    end
  end
  def **(power)
    raise  QuantitiesException.new("Can only raise a quantity to an integer power") unless power.is_a?(Fixnum)

    new_dims=self.class.dimensions*power
    q1=self; q1=q1.to_si unless q1.is_si?

    target_scale=q1.unit.scale*power
    target_value=q1.value**power

    existing_or_new_quantity new_dims,target_scale,target_value
  end
  def rt(power)
    raise  QuantitiesException.new("Can only do integer roots") unless power.is_a?(Fixnum)

    new_dims=self.class.dimensions/power
    q1=self; q1=q1.to_si unless q1.is_si?

    target_scale=q1.unit.scale/power
    target_value=q1.value**(1.0/power)
    existing_or_new_quantity new_dims,target_scale,target_value
  end
  def <=>(other)
    raise  QuantitiesException.new("Can only compare quantities with same dimensions") unless other.is_a?(Quantity) && self.class.dimensions=other.class.dimensions
    return to_base_unit.value<=>other.to_base_unit.value
  end

  def existing_or_new_quantity new_dims,target_scale,target_value
    if Quantities.quantities[new_dims]
      klass=Quantities.quantities[new_dims][0]
      unit=klass.best_si_unit Math.log10(target_value.abs) + target_scale
      return klass.new(target_value*10**(target_scale-unit.scale),unit)
    else
      qname=new_dims.to_s.gsub(/-/,'_')
      QuantityBuilder.build(qname) do
        dimensions new_dims.spec
        si_unit '0.0'+qname, '',new_dims.to_s ,1.0
        unless target_scale==0
          si_unit target_scale.to_s+qname, '', new_dims.to_s+'*10^'+target_scale.to_s,1.0*10**target_scale
        end
      end.klass.send(target_scale.to_s+qname,target_value)
    end
  end

  def to_base_unit
    self.send(self.class.base_unit.name)
  end

  def scale
    raise "sure!"

  end

  def base_unit_scale
    self.scale+self.unit.scale
  end

  def is_si?
    @unit.is_si?
  end

  def to_si
    return self if self.is_si?
    self.send(self.unit.si_convert_unit)
  end

  def rescale
    unless self.is_si?
      return self.to_base_unit.rescale
    end
    scale=Math.log10(self.value)+self.unit.scale

    unit_scales=self.class.si_unit_scales.sort

    if scale<unit_scales[0][0]
      return self.send unit_scales[0][1].name
    end
    if scale>=unit_scales.last[0]
      return self.send unit_scales.last[1].name
    end
    unit_scales.each_cons(2) do |us|
      if us[0][0]<=scale && us[1][0]>scale
        return self.send us[0][1].name
      end
    end
  end
  end
end