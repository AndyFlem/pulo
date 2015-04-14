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
      #Create a dimensions object based on the supplied specification and set it on the new class
      spec=Dimension.new(dims[0])
      @klass.dimensions=spec

      if Pulo.quantities[spec]
        #If a quantity has already been defined with this set of dimensions

        Pulo.quantities[spec].each do |quan_klass|
          #for each of the other quantities with the same dimensions
          # define a method on them with the name of this quantity
          quan_klass.instance_exec(@klass) do |other_klass|
            define_method other_klass.quantity_name.downcase do
              other_unit=other_klass.si_unit_scales[self.unit.scale]
              other_unit=other_klass.best_si_unit(Math.log10(self.value)+self.unit.scale) unless other_unit
              return other_klass.new(self.value*10**(self.unit.scale-other_unit.scale),other_unit)
            end
          end

          #and define a method on us for the reverse
          define_method_on_klass @klass, quan_klass.quantity_name.downcase do
            other_unit=quan_klass.si_unit_scales[self.unit.scale]
            other_unit=quan_klass.best_si_unit(Math.log10(self.value)+self.unit.scale) unless other_unit
            return quan_klass.new(self.value*10**(self.unit.scale-other_unit.scale),other_unit)
          end
        end
        Pulo.quantities[spec] << @klass
      else
        Pulo.quantities.merge!({spec=>[@klass]})
      end
    end

    def synonyms(*synonyms)
      synonyms.each do |synonym|
        @klass.synonyms << synonym
        Pulo.const_set(synonym,@klass.clone)
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

      #Class method for creating by unit name
      @klass.define_singleton_method("#{unit.name}") do |val|
        # noinspection RubyArgCount
        self.new val,unit
      end

      #Class method for creating by unit plural name
      unless unit.name.to_s==unit.plural
        @klass.define_singleton_method("#{unit.plural}") do |val|
          self.send(unit.name,val) #Could also be done as a method alias?
        end
      end

      #Class method for creating by unit abbreviated name
      unless unit.name.to_s==unit.abbreviation || unit.abbreviation==''
        @klass.define_singleton_method("#{unit.abbreviation}") do |val|
          self.send(unit.name,val) #Could also be done as a method alias?
        end
      end

      #Instance method for conversion to this unit by plural
      unless unit.name.to_s==unit.plural
        define_method_on_klass(@klass,"#{unit.plural}") do
          self.send(unit.name) #Could also be done as a method alias?
        end
      end

      #Instance method for conversion to this unit by abbreviation
      unless unit.name.to_s==unit.abbreviation || unit.abbreviation==''
        define_method_on_klass(@klass,"#{unit.abbreviation}") do
          self.send(unit.name) #Could also be done as a method alias?
        end
      end

      define_method_on_klass(@klass,"#{unit.name}") do
        #If its conversion to and from the same unit then just return self
        if self.unit.name==unit.name  ##TODO: Make == work for units
          return self
        end

        #Actual conversions depending on si or non-si from and to units
        case

          #si to si
          when self.unit.is_si? && unit.is_si?
            # noinspection RubyArgCount
            self.class.new self.value*10**(self.unit.scale-unit.scale),unit

          #si to non-si
          when self.unit.is_si? && !unit.is_si?
            to_unit=self.class.units[unit.name]
            if to_unit.si_convert_unit==self.unit.name
              intermediate_si=self
            else
              intermediate_si=self.send(to_unit.si_convert_unit)
            end
            # noinspection RubyArgCount
            self.class.new intermediate_si.value*to_unit.si_convert_factor,unit

          #non-si to si
          when !self.unit.is_si? && unit.is_si?
            # noinspection RubyArgCount
            intermediate_si=self.class.new self.value/self.unit.si_convert_factor,self.class.units[self.unit.si_convert_unit]
            if intermediate_si.unit==unit
              intermediate_si
            else
              intermediate_si.send(unit.name)
            end

          #non-si to no-si
          else
            #get the destination non-si unit definition
            to_unit=self.class.units[unit.name]

            #first convert self to si
            intermediate_si=self.send(self.unit.si_convert_unit)

            #then convert this si to the si 'partner' of the destination unit
            intermediate_si2=intermediate_si.send(to_unit.si_convert_unit)

            #lastly convert this to the final required non-si
            intermediate_si2.send(to_unit.name)
        end
      end
    end
  end
end
