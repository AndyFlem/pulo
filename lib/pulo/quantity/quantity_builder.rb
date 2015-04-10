# encoding: utf-8

module Pulo
  class QuantityBuilder

    @unit_group_name

    def self.build(name,&block)
      klass=Class.new(Quantity)
      Pulo.const_set(name,klass)
      QuantityBuilder.new(klass,&block)
    end

    def initialize(klass,&block)
      @klass=klass
      instance_eval(&block)
    end

    def klass
      @klass
    end

    private

    def define_method_on_klass(klass,method, &block)
      klass.send :define_method, method, &block
    end

    def dimensions(*dims)
      spec=Dimension.new(dims[0])
      @klass.dimensions=spec
      if Quantities.quantities[spec]
        other_klass=@klass
        Quantities.quantities[spec].each do |quan_klass|
          quan_klass.send :define_method, @klass.quantity_name.downcase do
            other_unit=other_klass.si_unit_scales[self.unit.scale]
            other_unit=other_klass.best_si_unit(Math.log10(self.value)+self.unit.scale) unless other_unit
            return other_klass.new(self.value*10**(self.unit.scale-other_unit.scale),other_unit)
          end
        end
        Quantities.quantities[spec] << @klass
      else
        Quantities.quantities.merge!({spec=>[@klass]})
      end

      if spec.is_base?
        Quantities.base_units.merge!({spec.spec.first[0]=>@klass})
      end
    end

    def constant(name,symbol,unit,value)
      @klass.define_singleton_method(name) do
        # noinspection RubyArgCount
        self.new value, self.units[unit]
      end
      unless symbol==''
        @klass.define_singleton_method(symbol) do
          # noinspection RubyArgCount
          self.new value, self.units[unit]
        end
      end
    end

    def si_unit(name,plural,abbreviation,scale)
      scale=Math.log10(scale)
      unit=SI_Unit.new(name,plural, abbreviation,scale)
      if scale==0
        @klass.base_unit=unit
      end
      define_unit_methods unit
      @klass.si_unit_scales.merge!({scale=>unit})

    end

    def non_si_unit(name,plural,abbreviation,si_convert_unit,si_convert_factor)
      unit=NonSI_Unit.new(name,plural, abbreviation, si_convert_unit, si_convert_factor)
      define_unit_methods unit
    end

    def define_unit_methods(unit)
      @klass.units.merge!({unit.name=>unit})

      @klass.define_singleton_method("#{unit.name}") do |val=nil|
        val=1 if val.nil?
        # noinspection RubyArgCount
        self.new val,unit
      end

      unless unit.name.to_s==unit.plural
        @klass.define_singleton_method("#{unit.plural}") do |val|
          self.send(unit.name,val)
        end
      end

      unless unit.name.to_s==unit.abbreviation || unit.abbreviation==''
        @klass.define_singleton_method("#{unit.abbreviation}") do |val|
          self.send(unit.name,val)
        end
      end

      define_method_on_klass(@klass,"#{unit.name}") do
        if self.unit.name==unit.name  ##TODO: Make == work for units
          return self
        end
        case
          when self.unit.is_si? && unit.is_si?
            # noinspection RubyArgCount
            self.class.new self.value*10**(self.unit.scale-unit.scale),unit
          when self.unit.is_si? && !unit.is_si?
            to_unit=self.class.units[unit.name]
            if to_unit.si_convert_unit==self.unit.name
              intermediate_si=self
            else
              intermediate_si=self.send(to_unit.si_convert_unit)
            end
            # noinspection RubyArgCount
            self.class.new intermediate_si.value*to_unit.si_convert_factor,unit
          when !self.unit.is_si? && unit.is_si?
            # noinspection RubyArgCount
            intermediate_si=self.class.new self.value/self.unit.si_convert_factor,self.class.units[self.unit.si_convert_unit]
            if intermediate_si.unit==unit
              intermediate_si
            else
              intermediate_si.send(unit.name)
            end
          else
            to_unit=self.class.units[unit.name]
            intermediate_si=self.send(self.unit.si_convert_unit)
            intermediate_si2=intermediate_si.send(to_unit.si_convert_unit)
            intermediate_si2.send(to_unit.name)
        end
      end

      unless unit.name.to_s==unit.plural
        define_method_on_klass(@klass,"#{unit.plural}") do
          self.send(unit.name)
        end
      end

      unless unit.name.to_s==unit.abbreviation || unit.abbreviation==''
        define_method_on_klass(@klass,"#{unit.abbreviation}") do
          self.send(unit.name)
        end
      end
    end

    def synonyms(*syns)
      syns.each do |syn|
        @klass.synonyms << syn
        Pulo.const_set(syn,@klass.clone)
      end
    end

  end
end
