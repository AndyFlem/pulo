require_relative '../lib/pulo'
require 'pp'

p=SteamProcess.new(supply_pressure: Pressure.psig(479.8),
              supply_quality:Dimensionless.n(1),
              supply_power: Power.million_btu_per_hour(60.2),
              condensate_temperature: Temperature.fahrenheit(150),
              condensate_recovery:Dimensionless.percent(50))

h=Header.new(pressure: Pressure.psig(150),inlet_temperature: Temperature.fahrenheit(465.9),energy_loss_pct: Dimensionless.percent(0.1))

b=Boiler.new(feedwater_pressure: Pressure.psig(15),
             blowdown_rate: Dimensionless.percent(2),
             combustion_efficiency:Efficiency.percent(85),
             steam_pressure: Pressure.psig(150),
             steam_temperature: Temperature.fahrenheit(465.9),
             steam_massflow: MassFlow.pounds_per_hour(95890))

d=Deaerator.new(deaerator_pressure: Pressure.psig(15),
                vent_rate: Dimensionless.percent(0.1),
                feedwater_massflow: b.feedwater_massflow,
                inlet_pressure: Pressure.psig(15),
                inlet_temperature: Temperature.fahrenheit(109.1),
                steam_pressure: h.outlet.pressure,
                steam_temperature: h.outlet.temperature
                )
puts '==Process=='
puts 'Inlet'
puts p.supply.specific_enthalpy.btu_per_pound
puts p.supply_massflow.pounds_per_hour
puts p.supply_power.million_btu_per_hour
puts 'Condensate'
puts p.condensate_massflow.pounds_per_hour
puts p.condensate.specific_enthalpy.btu_per_pound
puts p.condensate_power.million_btu_per_hour


puts '==Header=='
puts 'Inlet'
puts h.inlet.specific_enthalpy.btu_per_pound.to_s
puts 'Outlet'
puts h.outlet.specific_enthalpy.btu_per_pound.to_s
puts h.outlet.temperature.fahrenheit.to_s

puts '==Dearator=='
puts 'Steam'
puts d.steam.specific_enthalpy.btu_per_pound.to_s
puts d.steam.pressure.psig.to_s
puts d.steam.temperature.fahrenheit.to_s
puts d.steam.specific_enthalpy.btu_per_pound.to_s
puts d.steam_massflow.pounds_per_hour.to_s
puts d.steam_power.million_btu_per_hour.to_s
puts 'Inlet'
puts d.inlet.specific_enthalpy.btu_per_pound.to_s
puts d.inlet_power.million_btu_per_hour.to_s
puts d.inlet_massflow.pounds_per_hour.to_s
puts 'Vent'
puts d.vent.specific_enthalpy.btu_per_pound.to_s
puts d.vent_power.million_btu_per_hour.to_s
puts d.vent_massflow.pounds_per_hour.to_s
puts 'Feedwater'
puts d.feedwater.specific_enthalpy.btu_per_pound.to_s
puts d.feedwater_power.million_btu_per_hour.to_s
puts d.feedwater_massflow.pounds_per_hour.to_s

p '==Boiler=='
p 'Steam'
p b.steam.specific_enthalpy.btu_per_pound.to_s
p b.steam_power.million_btu_per_hour.to_s
p 'Feed water'
p b.feedwater_massflow.pounds_per_hour.to_s
p b.feedwater.specific_enthalpy.btu_per_pound.to_s
p b.feedwater.specific_entropy.btu_per_pound_rankine.to_s
p b.feedwater_power.million_btu_per_hour.to_s
p 'Blowdown'
p b.blowdown_massflow.pounds_per_hour.to_s
p b.blowdown.specific_enthalpy.btu_per_pound.to_s
p b.blowdown.specific_entropy.btu_per_pound_rankine.to_s
p b.blowdown_power.million_btu_per_hour.to_s
p 'Boiler'
p b.boiler_power.million_btu_per_hour.to_s
p b.fuel_power.million_btu_per_hour.to_s

t=TurbineBackpressure.new

