
module Pulo
  module Steam
    class SteamProcess

      attr_reader :supply, :condensate
      attr_reader :supply_pressure, :supply_quality, :process_power, :condensate_recovery
      attr_reader :supply_massflow, :condensate_massflow, :condensate_power
      def initialize(supply_pressure: nil, supply_quality:nil, process_power: nil, condensate_recovery: nil)
        raise "Need all parameters" unless supply_pressure && supply_quality && process_power &&  condensate_recovery

        @supply_pressure=supply_pressure
        @supply_quality=supply_quality
        @process_power=process_power
        @condensate_recovery=condensate_recovery

        @supply=WaterSteam.new(pressure: @supply_pressure, quality: @supply_quality)
        @condensate=WaterSteam.new(pressure: supply_pressure, quality: Dimensionless.n(0))
        @evap_energy=@supply.specific_enthalpy-@condensate.specific_enthalpy

        @supply_massflow=@process_power/@evap_energy
        @condensate_massflow=@supply_massflow*@condensate_recovery
        @condensate_power=@condensate.specific_enthalpy*@condensate_massflow
      end
    end
  end
end