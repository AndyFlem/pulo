
module Pulo

  class Deaerator
  attr_reader :steam, :feedwater,:vent,:inlet
  attr_reader :dearator_pressure,:vent_rate
  attr_reader :dearator_mass_flow

  def initialize(deaerator_pressure: nil,vent_rate: nil,feedwater_massflow: nil,inlet_pressure: nil,
                 inlet_temperature: nil,steam_pressure:nil, steam_temperature:nil)

    raise "Need all parameters" unless deaerator_pressure && vent_rate && feedwater_massflow && inlet_pressure && inlet_temperature && steam_pressure && steam_temperature

    @deaerator_pressure=deaerator_pressure
    @vent_rate=vent_rate

    @inlet=WaterSteam.new(pressure: inlet_pressure, temperature: inlet_temperature)

    @steam=WaterSteam.new(pressure: steam_pressure, temperature: steam_temperature)

    @vent=WaterSteam.new(pressure: deaerator_pressure, quality: Dimensionless.n(1))

    @feedwater=WaterSteam.new(pressure: deaerator_pressure, quality: Dimensionless.n(0))
    @feedwater.mass_flow=feedwater_massflow

    @vent.mass_flow=@feedwater.mass_flow*@vent_rate
    @deaereator_mass_flow=@vent.mass_flow+@feedwater.mass_flow
    @deaereator_power=@vent.energy_flow+@feedwater.energy_flow

    min_in_power=@inlet.specific_enthalpy*@deaereator_mass_flow
    add_pow=@deaereator_power-min_in_power
    @steam.mass_flow=add_pow/(@steam.specific_enthalpy-@inlet.specific_enthalpy)
    @inlet.mass_flow=@deaereator_mass_flow-@steam.mass_flow
  end

end

end