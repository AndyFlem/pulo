
module Pulo
  module Steam
    class Desuperheater

      attr_reader :inlet_steam,:outlet_steam,:water

      def initialize(inlet_pressure: nil, inlet_temperature: nil,
                     inlet_massflow: nil, outlet_massflow:nil)

        raise "Need all parameters" unless inlet_pressure && inlet_temperature && (inlet_massflow || outlet_massflow)

        @inlet_steam=WaterSteam.new(pressure: inlet_pressure, temperature: inlet_temperature)
        @outlet_steam=WaterSteam.new(pressure: inlet_pressure, quality: Dimensionless.n(1))
        @water=WaterSteam.new(pressure: Pressure.psig(0),temperature: Temperature.celsius(25))

        if inlet_massflow
          @inlet_steam.mass_flow=inlet_massflow
          @water.mass_flow=inlet_massflow*(@inlet_steam.specific_enthalpy-@outlet_steam.specific_enthalpy)/(@outlet_steam.specific_enthalpy-@water.specific_enthalpy)
          @outlet_steam.mass_flow=inlet_massflow+@water.mass_flow
        else
          @outlet_steam.mass_flow=outlet_massflow
          @water.mass_flow=outlet_massflow*(@inlet_steam.specific_enthalpy-@outlet_steam.specific_enthalpy)/(@inlet_steam.specific_enthalpy-@water.specific_enthalpy)
          @inlet_steam.mass_flow=outlet_massflow-@water.mass_flow
        end
      end
    end
  end
end