# encoding: utf-8

module Pulo
  module Steam
    class Boiler
      attr_reader :feedwater, :steam, :blowdown
      attr_reader :blowdown_rate, :combustion_efficiency
      attr_reader :boiler_power, :fuel_power

      def initialize(feedwater_pressure: nil,blowdown_rate: nil,combustion_efficiency:nil,steam_pressure: nil,
                     steam_temperature: nil,fuel_power: nil,
                     steam_massflow: nil,feedwater_massflow: nil)

        raise "Need all parameters" unless
            feedwater_pressure && blowdown_rate &&
            combustion_efficiency && steam_pressure &&
            (steam_temperature || fuel_power) &&
            (steam_massflow || feedwater_massflow)

        #steam_massflow=steam_massflow
        @blowdown_rate=blowdown_rate
        @combustion_efficiency=combustion_efficiency
        @steam_temperature=steam_temperature
        @feedwater_pressure=feedwater_pressure
        @steam_pressure=steam_pressure
        @fuel_power=fuel_power
        #feedwater_massflow=feedwater_massflow

        @blowdown=WaterSteam.new(pressure: @steam_pressure, quality: Dimensionless.new(0))
        if steam_massflow
          feedwater_massflow=steam_massflow/(1-@blowdown_rate)
        else
          steam_massflow=feedwater_massflow*(1-@blowdown_rate)
        end

        @blowdown.mass_flow=feedwater_massflow*@blowdown_rate
        #@blowdown_power=@blowdown.specific_enthalpy*@blowdown_massflow

        @feedwater=WaterSteam.new(pressure: @feedwater_pressure, quality: Dimensionless.new(0))
        @feedwater.mass_flow=feedwater_massflow
        #@feedwater_power=@feedwater.specific_enthalpy*@feedwater_massflow


        if @steam_temperature
          @steam=WaterSteam.new(pressure: @steam_pressure, temperature: @steam_temperature)
          @steam.mass_flow=steam_massflow
          #@steam_power=@steam.specific_enthalpy*@steam_massflow
          @boiler_power=@steam.energy_flow + @blowdown.energy_flow - @feedwater.energy_flow
          @fuel_power=@boiler_power/@combustion_efficiency
        else
          @boiler_power=@fuel_power*@combustion_efficiency
          steam_power=@boiler_power-@blowdown.energy_flow+@feedwater.energy_flow
          specific_enthalpy=steam_power/steam_massflow
          @steam=WaterSteam.new(pressure: @steam_pressure, specific_enthalpy: specific_enthalpy)
          @steam.mass_flow=steam_massflow
          raise "Boiler not boiling!" if @steam.if97_region=="1"
        end
      end
    end
  end
end