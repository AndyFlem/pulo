class Header
  attr_reader :inlet,:outlet
  attr_reader :pressure,:inlet_temperature,:mass_flow,:energy_loss_pct

  def initialize(pressure: nil,inlet_temperature: nil,energy_loss_pct: nil)

    raise "Need all parameters" unless pressure && inlet_temperature && energy_loss_pct
    @pressure=pressure
    @inlet_temperature=inlet_temperature
    @energy_loss_pct=energy_loss_pct

    @inlet=WaterSteam.new(temperature: inlet_temperature,pressure: pressure)
    @outlet=WaterSteam.new(pressure: pressure, specific_enthalpy: @inlet.specific_enthalpy*(1-energy_loss_pct))
  end
end