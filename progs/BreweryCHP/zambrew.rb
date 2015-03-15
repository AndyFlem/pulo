require_relative '../../lib/pulo'
require_relative 'coal'
$precision=4
$significant=true
$no_quantity_names=true

puts "SAB Lusaka"
puts "-------------------------------------"


coal=MaambaCoal.new(transport_distance: Length.kilometers(350))
puts coal.to_s

#brewery_thermal_demand=Energy.therm(1.4)/Volume.beer_barrel(1)
brewery_thermal_demand=VolumeEnergyDemand.megajoules_per_hectolitre(200)
zambrew_production=VolumeFlow.hectolitres_per_year(700000)
thermal_energy=zambrew_production*brewery_thermal_demand
coal_consumption=(thermal_energy/coal.lhv)
coal_cost=coal_consumption*coal.unit_cost

electricity_unit_cost=EnergyValue.dollars_per_kilowatt_hour(0.05)
electrical_power=Energy.kilowatt_hours(20)/Volume.beer_barrel(1)*zambrew_production


electricity_cost=electrical_power*electricity_unit_cost
total_energy_cost=(coal_cost+electricity_cost)
total_specific_energy_cost=(total_energy_cost)/zambrew_production
boiler_efficiency=Dimensionless.n(0.85)

process_power=(thermal_energy*boiler_efficiency)

steam_pressure=Pressure.psig(100)

p=SteamProcess.new(supply_pressure: steam_pressure,
                   supply_quality:Dimensionless.n(1),
                   process_power: process_power,
                   condensate_recovery: Dimensionless.n(0.8))

steam_massflow=p.supply_massflow
steam_power=steam_massflow*p.supply.specific_enthalpy
steam_volumeflow=p.supply_massflow*p.supply.specific_volume


puts "-------------------------------------"


puts "Thermal energy consumption: #{brewery_thermal_demand.megajoule_per_hectolitre}"
puts "SAB Lusaka production: #{zambrew_production.hectolitres_per_year}"
puts "Thermal energy demand: #{thermal_energy}"
puts "Process power: #{process_power}"

puts "-------------------------------------"

puts "Coal consumption:#{coal_consumption.tonnes_per_day} #{coal_consumption.tonnes_per_month} #{coal_consumption.tonnes_per_year}"
puts "Coal cost: #{(coal_cost).dollars_per_month} #{(coal_cost).dollars_per_year}"

puts "Electrical energy demand: #{electrical_power}"
puts "Electrical consumption: #{electrical_power.gigawatt_hours_per_year}"

puts "Electrical cost: #{electricity_cost.dollars_per_month}  #{electricity_cost.dollars_per_year}"

puts "Energy cost: #{(total_energy_cost).dollars_per_month} #{(total_energy_cost).dollars_per_year}"
puts "Energy cost: #{(total_specific_energy_cost).dollars_per_litre}"

puts "-------------------------------------"

puts"Steam temperature:  #{(p.supply.temperature.fahrenheit)} #{(p.supply.temperature.celsius)}"
puts"Steam pressure:  #{(p.supply.pressure.psig)} #{(p.supply.pressure.bar)}"
puts"Steam flow:  #{(steam_massflow).pounds_per_hour}"
puts"Steam power:  #{steam_power.million_btu_per_hour} #{steam_power.megawatts}"
puts"Steam cost:  #{(coal_cost/steam_massflow).dollars_per_pound} #{(coal_cost/steam_power).dollars_per_kilowatt_hour}"
puts"Condensate mass flow: #{p.condensate_massflow.pounds_per_hour}"
puts"Condensate flow: #{(p.condensate_massflow*p.condensate.specific_volume).litres_per_second}"

