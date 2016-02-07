# encoding: utf-8

require_relative 'pulo/version'
require 'bigdecimal'
require 'bigdecimal/util'
require 'yaml'

require_relative 'pulo/helpers'
require_relative 'pulo/formatting'
require_relative 'pulo/quantity_checker'
require_relative 'pulo/exceptions'

module Pulo

#Module instance variables to store global settings
  class << self
    attr_accessor :precision
    attr_accessor :significant_figures
    attr_accessor :supress_quantity_names

    def quantities; @quantities||={};end #hash with dimension_spec as the key

    def help
      @quantities.each do |dim|

        dim[1].each do |quan|
          names=quan.quantity_name
          if quan.synonyms.length>0
            names += ', ' + quan.synonyms.join(', ')
          end

          puts names
          puts '---------------------------------------------------------------------------------------'
          puts '[' + dim[0].to_s + ']'
          puts quan.units_sorted #.each do |unit_def|
            #puts unit_def
          #end
          puts ''
        end
      end
    end
  end
end
Pulo.precision = 2
Pulo.significant_figures = false
Pulo.supress_quantity_names = false

#require_relative 'pulo/quantity/quantities'
require_relative 'pulo/quantity/quantity'
require_relative 'pulo/quantity/quantity_builder'
require_relative 'pulo/quantity/unit'
require_relative 'pulo/quantity/dimension'

require_relative 'pulo/quantity/quantity_definitions/basic'
require_relative 'pulo/quantity/quantity_definitions/area_volume'
require_relative 'pulo/quantity/quantity_definitions/velocity_acc_flow'
require_relative 'pulo/quantity/quantity_definitions/force_power'
require_relative 'pulo/quantity/quantity_definitions/energy'
require_relative 'pulo/quantity/quantity_definitions/rotation'
require_relative 'pulo/quantity/quantity_definitions/fluids'
require_relative 'pulo/quantity/quantity_definitions/value'

require_relative 'pulo/quantity/quantity_groups/quantity_groups'

require_relative 'pulo/figure/figure2d'
require_relative 'pulo/figure/figure3d'

require_relative 'pulo/machine/steam/water_steam'

require_relative 'pulo/machine/steam/boiler'
require_relative 'pulo/machine/steam/deaerator'
require_relative 'pulo/machine/steam/boiler_deaerator'
require_relative 'pulo/machine/steam/desuperheater'
require_relative 'pulo/machine/steam/header'
require_relative 'pulo/machine/steam/steam_process'
require_relative 'pulo/machine/steam/steam_turbine'

require_relative 'pulo/machine/mechanics/moments_of_inertia'

require_relative 'pulo/quantity/numeric_overloads'

require_relative 'pulo/frames/frame'
require_relative 'pulo/frames/frame_cell'
require_relative 'pulo/frames/frame_row'
require_relative 'pulo/frames/frame_column'

require_relative 'pulo/tables/tables'