# encoding: utf-8

require_relative '../../../../lib/pulo/machine/steam/if97'

module Pulo
  module Steam
    class WaterSteam
      attr_accessor :pressure,:temperature
      attr_accessor :specific_volume,:specific_volume_liquid
      attr_accessor :specific_internal_energy,:specific_entropy,:specific_enthalpy
      attr_accessor :saturation_temperature, :saturation_pressure
      attr_accessor :state,:if97_region
      attr_accessor :quality
      attr_reader :mass_flow, :energy_flow

      def to_s(us: false)
        r=case if97_region
             when "1"
               "Water "
             when "2" || "3"
               "Superheated "
            when "4"
              case quality
                when Dimensionless.n(1)
                  "Dry steam "
                when Dimensionless.n(0)
                  "Water "
                else
                  "Quality:#{quality} "
              end

             else
               if97_region.to_s
           end.ljust(12)
        if us
          r+="mf:#{mass_flow.pounds_per_hour.to_s(0).rjust(15)} ef:#{energy_flow.millions_btu_per_hour.to_s.rjust(17)} p:#{pressure.psig.to_s.rjust(9)}  t:#{temperature.fahrenheit.to_s(0).rjust(8)}  h:#{specific_enthalpy.btu_per_pound.to_s(0).rjust(15)} s:#{specific_entropy.btu_per_pound_rankine}"
        else
          r+="mf:#{mass_flow.kilograms_per_second.to_s(0).rjust(15)} ef:#{energy_flow.megawatts.to_s.rjust(17)} p:#{pressure.megapascals} t:#{temperature.kelvin} #{temperature.celsius} h:#{specific_enthalpy.kilojoules_per_kilogram} s:#{specific_entropy.kilojoules_per_kilogram_kelvin}"
        end

      end

      def mass_flow=(val)
        @mass_flow=val
        if @specific_enthalpy
          @energy_flow=@mass_flow*@specific_enthalpy
        end
      end
      def energy_flow=(val)
        @energy_flow=val
        if @specific_enthalpy
          @mass_flow=@energy_flow/@specific_enthalpy
        end
      end

      def initialize(pressure: nil,temperature: nil,specific_entropy: nil, specific_enthalpy: nil, quality: nil)

        return if !pressure && !temperature && !specific_entropy && !specific_enthalpy && !quality

        @temperature=temperature.kelvin if temperature
        @pressure=pressure.megapascals if pressure
        @specific_entropy=specific_entropy.kilojoules_per_kilogram_kelvin if specific_entropy
        @specific_enthalpy=specific_enthalpy.kilojoules_per_kilogram if specific_enthalpy
        @quality=quality.n if quality
        @mass_flow=MassFlow.new(0)
        @energy_flow=Power.new(0)

        if @temperature && (@temperature>Temperature.kelvin(1073.15) || @temperature<Temperature.kelvin(273.15))
          raise "Temperature outside valid range 273.15K to 1073.15K"
          #TODO: Implement R5
        end
        if @pressure && (@pressure<Pressure.megapascals(0) || @pressure>Pressure.megapascals(100))
          raise "Pressure outside valid range 0MPa to 100MPa"
        end

        if (quality && (pressure || temperature))
          @if97_region="4"
          if temperature
            @pressure=IF97.pressure_from_temperature_r4 @temperature
          else
            @temperature=IF97.temperature_from_pressure_r4 @pressure
          end
          fluid=WaterSteam.new
          IF97.other_props_r1(@temperature,@pressure,fluid)

          gas=WaterSteam.new
          IF97.other_props_r2(@temperature,@pressure,gas)

          @specific_enthalpy=fluid.specific_enthalpy+(gas.specific_enthalpy-fluid.specific_enthalpy)*@quality
          @specific_entropy=fluid.specific_entropy+(gas.specific_entropy-fluid.specific_entropy)*@quality
          @specific_volume=fluid.specific_volume+(gas.specific_volume-fluid.specific_volume)*@quality
          @specific_internal_energy=fluid.specific_internal_energy+(gas.specific_internal_energy-fluid.specific_internal_energy)*@quality
          return
        end

        if (temperature && !pressure && !specific_entropy  && !specific_enthalpy) || (!temperature && pressure && !specific_entropy && !specific_enthalpy)
          #if97 region 4 saturated steam
          @if97_region="4"
          if temperature
            @pressure=IF97.pressure_from_temperature_r4 @temperature
          else
            @temperature=IF97.temperature_from_pressure_r4 @pressure
          end
          @saturation_temperature=@temperature
          @saturation_pressure=@pressure
          return
        end

        if @temperature && @pressure
          #determine region
          if @temperature<Temperature.kelvin(623.15)
            @saturation_pressure=IF97.pressure_from_temperature_r4 @temperature
            @saturation_temperature=IF97.temperature_from_pressure_r4 @pressure
            if @pressure<@saturation_pressure
              @if97_region="2"
              IF97.other_props_r2(@temperature,@pressure,self)
            else
              @if97_region="1"
              IF97.other_props_r1(@temperature,@pressure,self)
            end
          else
            p_b23=IF97.pressure_from_b23(@temperature)
            if @pressure>p_b23
              @if97_region="3"
              #TODO: Implement R3 forward
            else
              @if97_region="2"
              IF97.other_props_r2(temperature,@pressure,self)
            end
          end
          return
        end

        if @pressure && @specific_enthalpy
          region=IF97.get_region_ph(@pressure,@specific_enthalpy)
          case region
            when 1
              #raise "Reverse for region 1 not implemented"
              IF97.temperature_from_pressure_enthalpy_r1(@pressure,@specific_enthalpy,self)
              IF97.other_props_r1(@temperature,@pressure,self)
              @if97_region="1"
            when 2
              IF97.temperature_from_pressure_enthalpy_r2(@pressure,@specific_enthalpy,self)
              IF97.other_props_r2(@temperature,@pressure,self)
              @if97_region="2"
            when 3
              raise "Reverse for region 3 not implemented"
              @if97_region="3"
            when 4
              @temperature=IF97.temperature_from_pressure_r4 @pressure
              @if97_region="4"

              fluid=WaterSteam.new
              IF97.other_props_r1(@temperature,@pressure,fluid)

              gas=WaterSteam.new
              IF97.other_props_r2(@temperature,@pressure,gas)

              @quality=(self.specific_enthalpy-fluid.specific_enthalpy)/(gas.specific_enthalpy-fluid.specific_enthalpy)
              @specific_entropy=fluid.specific_entropy+(gas.specific_entropy-fluid.specific_entropy)*@quality
              @specific_volume=fluid.specific_volume+(gas.specific_volume-fluid.specific_volume)*@quality
              @specific_internal_energy=fluid.specific_internal_energy+(gas.specific_internal_energy-fluid.specific_internal_energy)*@quality
          end
          return
        end

        if @pressure && @specific_entropy
          #get the r1,r2 boundary saturation entropy
          region=IF97.get_region_ps(@pressure,@specific_entropy)

          case region
            when 1
              IF97.temperature_from_pressure_entropy_r1(@pressure,@specific_entropy,self)
              IF97.other_props_r1(@temperature,@pressure,self)
              @if97_region="1"
            when 2
              IF97.temperature_from_pressure_entropy_r2(@pressure,@specific_entropy,self)
              IF97.other_props_r2(@temperature,@pressure,self)
              @if97_region="2"
            when 3
              raise "Reverse for region 3 not implemented"
              @if97_region="3"
            when 4
              @temperature=IF97.temperature_from_pressure_r4 @pressure
              @if97_region="4"

              fluid=WaterSteam.new
              IF97.other_props_r1(@temperature,@pressure,fluid)

              gas=WaterSteam.new
              IF97.other_props_r2(@temperature,@pressure,gas)

              @quality=(self.specific_entropy-fluid.specific_entropy)/(gas.specific_entropy-fluid.specific_entropy)
              @specific_enthalpy=fluid.specific_enthalpy+(gas.specific_enthalpy-fluid.specific_enthalpy)*@quality
              @specific_volume=fluid.specific_volume+(gas.specific_volume-fluid.specific_volume)*@quality
              @specific_internal_energy=fluid.specific_internal_energy+(gas.specific_internal_energy-fluid.specific_internal_energy)*@quality
          end

          case region
            when 1
              IF97.temperature_from_pressure_entropy_r1(@pressure,@specific_entropy,self)
              @if97_region="1"
            when 2
              IF97.temperature_from_pressure_entropy_r2(@pressure,@specific_entropy,self)
              @if97_region="2"
            when 3
              raise "Reverse for region 3 not implemented"
              @if97_region="3"
            when 4
              @temperature=IF97.temperature_from_pressure_r4 @pressure
              @if97_region="4"

              fluid=WaterSteam.new
              IF97.other_props_r1(@temperature,@pressure,fluid)

              gas=WaterSteam.new
              IF97.other_props_r2(@temperature,@pressure,gas)

              @quality=(self.specific_entropy-fluid.specific_entropy)/(gas.specific_entropy-fluid.specific_entropy)
              @specific_enthalpy=fluid.specific_enthalpy+(gas.specific_enthalpy-fluid.specific_enthalpy)*@quality
              @specific_volume=fluid.specific_volume+(gas.specific_volume-fluid.specific_volume)*@quality
              @specific_internal_energy=fluid.specific_internal_energy+(gas.specific_internal_energy-fluid.specific_internal_energy)*@quality
            return
          end
        end
      end
    end
  end
end