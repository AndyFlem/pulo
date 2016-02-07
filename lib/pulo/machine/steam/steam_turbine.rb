module Pulo
  module Steam
    class SteamTurbine
      attr_reader :inlet_steam,:outlet_steam
      attr_reader :isentropic_efficiency,:mechanical_efficiency
      attr_reader :electrical_power

      def initialize(inlet_pressure: nil, inlet_temperature:nil,outlet_pressure: nil,isentropic_efficiency: nil, mechanical_efficiency: nil,
                    electrical_power: nil, mass_flow:nil)

        raise "Need all parameters" unless isentropic_efficiency && mechanical_efficiency &&
            inlet_pressure && outlet_pressure && inlet_temperature &&
            (electrical_power || mass_flow)

        @electrical_power=electrical_power
        @isentropic_efficiency=isentropic_efficiency
        @mechanical_efficiency=mechanical_efficiency

        @inlet_steam=WaterSteam.new(pressure: inlet_pressure, temperature: inlet_temperature)
        outlet_ideal=WaterSteam.new(pressure: outlet_pressure, specific_entropy: @inlet_steam.specific_entropy)
        outlet_enthalpy=outlet_enthalpy_from_isentropic(@inlet_steam.specific_enthalpy,outlet_ideal.specific_enthalpy,@isentropic_efficiency)
        @outlet_steam=WaterSteam.new(pressure: outlet_pressure,specific_enthalpy: outlet_enthalpy)
        if @electrical_power
          energy_output=@electrical_power/@mechanical_efficiency
          outlet_steam.mass_flow=energy_output/(@inlet_steam.specific_enthalpy-outlet_enthalpy)
        else
          outlet_steam.mass_flow=mass_flow
          energy_output=mass_flow*(@inlet_steam.specific_enthalpy-outlet_enthalpy)
          @electrical_power=energy_output*@mechanical_efficiency
        end
        inlet_steam.mass_flow=outlet_steam.mass_flow
      end

      def isentropic_efficiency_from_enthalpy inlet_enthalpy,outlet_enthalpy,ideal_outlet_enthalpy
        (inlet_enthalpy-outlet_enthalpy)/(inlet_enthalpy-ideal_outlet_enthalpy)
      end
      def outlet_enthalpy_from_isentropic inlet_enthalpy,ideal_outlet_enthalpy,isentropic_efficiency
        inlet_enthalpy-isentropic_efficiency*(inlet_enthalpy-ideal_outlet_enthalpy)
      end
    end
  end
end