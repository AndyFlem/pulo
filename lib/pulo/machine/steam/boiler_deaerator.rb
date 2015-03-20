
module Pulo

  class BoilerDeaerator

  attr_reader :boiler,:deaerator

  def initialize (
    header_pressure: nil,header_temperature:  nil,outlet_massflow: nil,deaerator_pressure: nil,deaerator_vent_rate: nil, condensate_massflow: nil,
    boiler_efficiency: nil,boiler_blowdown_rate: nil,condensate_temperature: nil,condensate_pressure: nil,
    makeup_temperature: nil,fuel_power: nil,additional_makeup: nil)

    raise "Need all params" unless header_pressure && outlet_massflow && deaerator_pressure && condensate_pressure && condensate_massflow
    deaerator_vent_rate && boiler_efficiency && boiler_blowdown_rate && condensate_temperature && makeup_temperature && additional_makeup &&
    (header_temperature || fuel_power)

    condensate=WaterSteam.new(pressure: condensate_pressure, temperature: condensate_temperature)
    makeup=WaterSteam.new(temperature: makeup_temperature, pressure: Pressure.psig(0.0))

    boiler_feed_massflow=outlet_massflow+outlet_massflow*(deaerator_vent_rate+boiler_blowdown_rate) #Starting assumption

    begin
      boiler_feed_massflow+=MassFlow.pounds_per_hour(50)
      if fuel_power
        b=Boiler.new(
            feedwater_pressure: deaerator_pressure,
            blowdown_rate: boiler_blowdown_rate,
            combustion_efficiency: boiler_efficiency,
            steam_pressure: header_pressure,
            fuel_power: fuel_power,
            feedwater_massflow: boiler_feed_massflow)
        header_temperature=b.steam.temperature
      else
        b=Boiler.new(
            feedwater_pressure: deaerator_pressure,
            blowdown_rate: boiler_blowdown_rate,
            combustion_efficiency: boiler_efficiency,
            steam_pressure: header_pressure,
            steam_temperature: header_temperature,
            feedwater_massflow: boiler_feed_massflow)
      end

      makeup_massflow=boiler_feed_massflow*(deaerator_vent_rate+boiler_blowdown_rate)+additional_makeup
      #condensate_massflow=outlet_massflow*condensate_return_rate
      deaerator_feed_enthalpy=(
              condensate.specific_enthalpy*condensate_massflow+
              makeup.specific_enthalpy*makeup_massflow)/(makeup_massflow+condensate_massflow)

      deaerator_feed=WaterSteam.new(pressure: deaerator_pressure, specific_enthalpy: deaerator_feed_enthalpy)
      d=Deaerator.new(
          deaerator_pressure: deaerator_pressure,vent_rate: deaerator_vent_rate,
          feedwater_massflow: boiler_feed_massflow,inlet_pressure: deaerator_feed.pressure,
          inlet_temperature: deaerator_feed.temperature,steam_pressure:header_pressure,
          steam_temperature: header_temperature)

      test_outlet_massflow=b.steam.mass_flow-d.steam.mass_flow
    end while (outlet_massflow-test_outlet_massflow)/outlet_massflow>Dimensionless.percent(0.1)
    @boiler=b
    @deaerator=d
  end
end

end
