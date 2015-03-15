require_relative '../../lib/pulo'

$precision=2
$significant=false
$no_quantity_names=true

class WtE
  attr_reader :waters, :turbine1, :turbine2,:electrical_power,
              :parasitic_power,:export_power,:fuel_power,:electricity_unit_value,:thermal_unit_value,
              :fuel_conversion_efficiency,:power_heat_ratio,:steam_value,:electricity_value,:total_value,
              :value_from_fuel,:fuel_consumption

  def initialize(
    waste_calorific_lhv: SpecificEnergy.btu_per_pound(4000),
    hp_pressure:Pressure.psig(800),
    hp_temperature: Temperature.fahrenheit(700),
    hp_massflow: MassFlow.pounds_per_hour(15000+11000+11000),
    process_massflow: MassFlow.pounds_per_hour(14620+11000+11000),
    process_pressure: Pressure.psig(100),
    parasitic_electricity_rate: 80, #kilowatts per tonne per hour fuel
    thermal_unit_value: EnergyValue.dollars_per_kilowatt_hour(0.01698),
    electricity_unit_value: EnergyValue.dollars_per_kilowatt_hour(0.045)
    )
    @thermal_unit_value=thermal_unit_value
    @electricity_unit_value=electricity_unit_value

    boiler_feed_pressure=Pressure.psig(15)
    boiler_efficiency=Dimensionless.percent(85)
    blowdown_rate=Dimensionless.percent(5)
    deaerator_vent_rate=Dimensionless.percent(5)
    condensing_turbine_outlet_pressure=Pressure.psig(0)
    condensate_return_rate=Dimensionless.percent(100)
    condensate_temperature=Temperature.fahrenheit(150)
    makeup_temperature=Temperature.fahrenheit(50)
    turbine1_isentropic_efficiency=Dimensionless.percent(65)
    turbine2_isentropic_efficiency=Dimensionless.percent(65)
    turbine_mechelec_efficiency=Dimensionless.percent(95)

    @waters={
        boiler_steam: nil, boiler_blowdown: nil, boiler_feed: nil, deaerator_steam: nil,deaerator_vent: nil,
        deaerator_feed: nil, hp_turbine_inlet: nil,hp_turbine_outlet: nil, lp_turbine_inlet: nil,lp_turbine_outlet: nil,
        desuperheater_water: nil, desuperheater_inlet: nil, process: nil,
        makeup_water: nil, condensate: nil, condensate_loss: nil}

    @turbine1=SteamTurbine.new(inlet_pressure: hp_pressure, inlet_temperature:hp_temperature,
                              outlet_pressure: process_pressure,isentropic_efficiency: turbine1_isentropic_efficiency,
                              mechanical_efficiency: turbine_mechelec_efficiency,mass_flow:hp_massflow)
    @waters[:hp_turbine_inlet]=@turbine1.inlet_steam
    @waters[:hp_turbine_outlet]=@turbine1.outlet_steam

    despuper=Desuperheater.new(
        inlet_pressure: @waters[:hp_turbine_outlet].pressure,inlet_temperature: @waters[:hp_turbine_outlet].temperature,
        outlet_massflow: process_massflow)

    @waters[:process]=despuper.outlet_steam
    @waters[:desuperheater_water]=despuper.water
    @waters[:desuperheater_inlet]=despuper.inlet_steam

    @turbine2=SteamTurbine.new(inlet_pressure: @turbine1.outlet_steam.pressure, inlet_temperature:@turbine1.outlet_steam.temperature,
                              outlet_pressure: condensing_turbine_outlet_pressure,isentropic_efficiency: turbine2_isentropic_efficiency,
                              mechanical_efficiency: turbine_mechelec_efficiency,mass_flow:hp_massflow-@waters[:desuperheater_inlet].mass_flow)

    @waters[:lp_turbine_inlet]=@turbine2.inlet_steam
    @waters[:lp_turbine_outlet]=@turbine2.outlet_steam

    condensate=WaterSteam.new(temperature: condensate_temperature, pressure: process_pressure)
    condensate_loss=WaterSteam.new(temperature: condensate_temperature, pressure: process_pressure)
    condensate.mass_flow=@waters[:process].mass_flow*condensate_return_rate
    @waters[:condensate]=condensate
    @waters[:condensate_loss]=condensate_loss
    @waters[:condensate_loss].mass_flow=@waters[:process].mass_flow*(1-condensate_return_rate)

    boiler_deaerator=BoilerDeaerator.new(
        header_pressure: hp_pressure,header_temperature:  hp_temperature,
        outlet_massflow: @waters[:hp_turbine_inlet].mass_flow,deaerator_pressure: boiler_feed_pressure,
        deaerator_vent_rate: deaerator_vent_rate, condensate_massflow: @waters[:condensate].mass_flow,
        boiler_efficiency: boiler_efficiency,boiler_blowdown_rate: blowdown_rate,
        condensate_temperature: @waters[:condensate].temperature,condensate_pressure: @waters[:condensate].pressure,
        makeup_temperature: makeup_temperature,additional_makeup: @waters[:condensate_loss].mass_flow)

    boiler=boiler_deaerator.boiler
    deaerator=boiler_deaerator.deaerator

    @waters[:boiler_feed]=boiler.feedwater
    @waters[:boiler_steam]=boiler.steam
    @waters[:boiler_blowdown]=boiler.blowdown
    @waters[:deaerator_steam]=deaerator.steam
    @waters[:deaerator_vent]=deaerator.vent
    @waters[:deaerator_feed]=deaerator.inlet
    @fuel_power=boiler.fuel_power
    @fuel_consumption=@fuel_power/waste_calorific_lhv


    @electrical_power=@turbine1.electrical_power+@turbine2.electrical_power
    @parasitic_power=Power.kilowatts(parasitic_electricity_rate*@fuel_consumption.tonnes_per_hour.value)
    @export_power=@electrical_power-@parasitic_power

    @fuel_conversion_efficiency=((@electrical_power+@waters[:process].energy_flow)/boiler.fuel_power)
    @power_heat_ratio=@electrical_power/@waters[:process].energy_flow
    @steam_value=thermal_unit_value*@waters[:process].energy_flow
    @electricity_value=electricity_unit_value*@export_power
    @total_value=@steam_value+@electricity_value
    @value_from_fuel=@total_value/@fuel_consumption

  end

  def to_s
    waters.each do |water|
      begin
        puts "#{water[0].to_s.ljust(20)} #{water[1].to_s(us: true)}"
      end unless water[1]==nil
    end

    puts "Fuel consumption: #{(fuel_consumption).tonnes_per_hour}"
    puts "Fuel power: #{fuel_power.megawatts}"
    puts "Process power: #{waters[:process].energy_flow.megawatts} #{(waters[:process].energy_flow/fuel_power).percent} of fuel"
    puts "Turbine outputs t1: #{turbine1.electrical_power.megawatts} t2: #{turbine2.electrical_power.megawatts} tot: #{(electrical_power).megawatts}  #{(electrical_power/fuel_power).percent} of fuel"
    puts "Parasitic power:#{parasitic_power.megawatts} #{(parasitic_power/electrical_power).percent} of output. Export power: #{export_power.megawatts}"
    puts "Fuel conversion efficiency #{fuel_conversion_efficiency.percent}"
    puts "Power/heat ratio: #{power_heat_ratio}"

    puts "Value: steam:#{thermal_unit_value.dollars_per_kilowatt_hour} electricity:#{electricity_unit_value.dollars_per_kilowatt_hour}"
    puts "Value: steam:#{steam_value.dollars_per_month} #{(steam_value/total_value).percent} electric:#{electricity_value.dollars_per_month} #{(electricity_value/total_value).percent} total: #{total_value.dollars_per_month}"
    puts "Value from fuel: #{value_from_fuel.dollars_per_tonne} steam:#{(steam_value/fuel_consumption).dollars_per_tonne} electricity:#{(electricity_value/fuel_consumption).dollars_per_tonne}"
  end
end

puts "fuel\tmass flow\tvalue from fuel"
process_flows=(2000..38000).step(1000)
process_flows.each do |mf|
  wte=WtE.new(process_massflow: MassFlow.pounds_per_hour(mf))
  puts "#{wte.fuel_consumption.tonnes_per_hour.value}\t#{mf}\t#{wte.value_from_fuel.value}\t#{wte.electrical_power.megawatts.value}"
end