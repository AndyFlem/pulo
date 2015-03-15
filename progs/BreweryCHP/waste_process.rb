require_relative '../../lib/pulo'

$precision=2
$significant=false
$no_quantity_names=true

#plastic_cost=MassValue.dollars_per_pound(0.3)
#puts plastic_cost.dollars_per_tonne
#plastic_calorific=SpecificEnergy.megajoules_per_kilogram(30)
#puts (plastic_cost/plastic_calorific).dollars_per_megajoule
#puts @coal_unit_cost/@maamba_coal_lhv
#waste_calorific_lhv=SpecificEnergy.btu_per_pound(4000)
#waste_consumption=coal_consumption*coal.lhv/waste_calorific_lhv
#puts "Waste calorific value #{waste_calorific_lhv.megajoules_per_tonne} #{waste_calorific_lhv.btu_per_pound} #{(waste_calorific_lhv/coal.maamba_coal_lhv).percent} of coal"
#puts "Waste consumption #{waste_consumption.tonnes_per_day} #{waste_consumption.tonnes_per_hour} #{waste_consumption.tonnes_per_year}"



waste_calorific_lhv=SpecificEnergy.btu_per_pound(4000)
throughput=MassFlow.tonnes_per_hour(5)
hp_pressure=Pressure.psig(700)
lp_pressure=Pressure.psig(100)

hp_massflow=MassFlow.pounds_per_hour(25000)
process_massflow=MassFlow.pounds_per_hour(14620)

waters={
    boiler: nil, boiler_blowdown: nil, boiler_feed: nil, deaerator_steam: nil,deaerator_vent: nil,
    deaerator_feed: nil, hp_turbine_inlet: nil,hp_turbine_outlet: nil, lp_turbine_inlet: nil,lp_turbine_outlet: nil,
    desuperheater_water: nil, desuperheater_inlet: nil, process: nil,
    makeup_water: nil, condensate: nil}


fuel_power=waste_calorific_lhv*throughput
bd=BoilerDeaerator.new(header_pressure: hp_pressure,
    outlet_massflow: hp_massflow,
    deaerator_pressure: Pressure.psig(15),
    deaerator_vent_rate: Dimensionless.percent(5),
    boiler_efficiency: Dimensionless.percent(85),
    boiler_blowdown_rate: Dimensionless.percent(5),
    condensate_temperature: Temperature.fahrenheit(150),
    makeup_temperature: Temperature.fahrenheit(50),
    fuel_power: fuel_power)

b=bd.boiler
d=bd.deaerator
waters[:boiler_feed]=b.feedwater
waters[:boiler]=b.steam
waters[:boiler_blowdown]=b.blowdown
waters[:deaerator_steam]=d.steam
waters[:deaerator_feed]=d.inlet
waters[:deaerator_vent]=d.vent
waters[:condensate]=bd.condensate
waters[:makeup_water]=bd.makeup

t=SteamTurbine.new(isentropic_efficiency: Dimensionless.percent(60),
                   mechanical_efficiency: Dimensionless.percent(95),
                   inlet_pressure: b.steam.pressure,
                   inlet_temperature: b.steam.temperature,
                   outlet_pressure: lp_pressure,
                   mass_flow: b.steam.mass_flow-d.steam.mass_flow)

waters[:hp_turbine_inlet]=t.inlet_steam
waters[:hp_turbine_outlet]=t.outlet_steam

ds=Desuperheater.new(inlet_pressure: t.outlet_steam.pressure, inlet_temperature: t.outlet_steam.temperature, inlet_massflow: process_massflow)

t2_massflow=t.outlet_steam.mass_flow-process_massflow
t2=SteamTurbine.new(isentropic_efficiency: Dimensionless.percent(60),
                    mechanical_efficiency: Dimensionless.percent(95),
                    inlet_pressure: hp_pressure,
                    outlet_pressure: Pressure.psig(-5),
                    inlet_temperature: b.steam.temperature,
                    mass_flow: t2_massflow)
waters[:lp_turbine_inlet]=t2.inlet_steam
waters[:lp_turbine_outlet]=t2.outlet_steam
waters[:desuperheater_inlet]=ds.inlet_steam
waters[:desuperheater_water]=ds.water
waters[:process]=ds.outlet_steam

electrical_power=t2.electrical_power + t.electrical_power
steam_value=process_massflow*MassValue.dollars_per_pound(0.03)
electrical_value=electrical_power*EnergyValue.dollars_per_kilowatt_hour(0.05)

puts "Waste #{waste_calorific_lhv.megajoules_per_kilogram} #{waste_calorific_lhv.btu_per_pound}"
puts "Fuel #{b.fuel_power.million_btu_per_hour} #{b.fuel_power.megawatts} Boiler #{b.boiler_power.million_btu_per_hour} #{b.boiler_power.megawatts}"

puts "Boiler outlet #{b.steam.temperature.fahrenheit} #{b.steam.pressure.psig} #{b.steam.specific_enthalpy.btu_per_pound}"
puts "Boiler outlet #{b.steam.energy_flow.million_btu_per_hour} #{b.steam.energy_flow.megawatts}"
puts "T1 Electrical power #{t.electrical_power.megawatts}"
puts "T1 steam #{t.outlet_steam.temperature.fahrenheit} #{t.outlet_steam.specific_enthalpy*process_massflow} #{t.outlet_steam.pressure.psig} "
puts "T1 WARNING Turbine outlet if97 region #{t.outlet_steam.if97_region}" if t.outlet_steam.if97_region=="4"
#puts "Desuperheater outlet #{ds.outlet_steam.temperature.fahrenheit} #{ds.outlet_steam.pressure.psig} x#{ds.outlet_steam.quality} #{ds.inlet_massflow.pounds_per_hour} #{ds.water_massflow.pounds_per_hour} #{ds.outlet_massflow.pounds_per_hour} #{ds.outlet_power.megawatts}"
puts "T2 massflow #{t2_massflow.pounds_per_hour}"
puts "T2 Electrical power #{t2.electrical_power.megawatts}"
puts "T2 Turbine outlet temperature #{t2.outlet_steam.temperature.fahrenheit}"
puts "T2 Turbine outlet pressure #{t2.outlet_steam.pressure.psig}"
puts "Electrical power #{electrical_power.megawatts}"
puts "Steam value #{steam_value.dollars_per_month}"
puts "Electricity value #{electrical_value.dollars_per_month}"
puts "Total value #{(steam_value + electrical_value).dollars_per_month}"

waters.each do |water|
  begin
    puts "#{water[0].to_s.ljust(20)} #{water[1].to_s(us: true)}"
  end unless water[1]==nil
end