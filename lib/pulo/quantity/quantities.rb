# encoding: utf-8

module Pulo
  class Quantities
    class << self
      def quantities; @quantities||={};end #hash with dimension_spec as the key
      def base_units; @base_units||={};end

#      def help
#        mem=""
#        @quantities.each do |quan|
#          mem+=quan[0].to_s + ":\n"
#          quan[1].each do |qu|
#            mem += "\t" + qu.quantity_name + " "
#            qu.synonyms.each do |syn|
#              mem += syn.to_s.gsub(':','') + " "
#            end
#            mem += "\n"
#          end
#        end
#        mem
#      end

      #def unit_from_dimensions dim_spec
      #  dim_spec.spec.inject('') do |mem,dim|
      #    mem+="#{self.base_units[dim[0]].base_unit.abbreviation.to_s}#{dim[1]!=1 ? super_digit(dim[1]) : ''}"
      #  end
      #end
    end
  end
end