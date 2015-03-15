require_relative '../../lib/pulo'
require_relative 'coal'
$precision=4

process_pressure=Pressure.bar(8)
steady_massflow=MassFlow.tonnes_per_hour(5)
peak_massflow=MassFlow.tonnes_per_hour(10)

steam=WaterSteam.new(pressure: process_pressure, quality: Dimensionless.n(1))

energy_flow=steam.specific_enthalpy*steady_massflow
puts energy_flow.megawatts
puts energy_flow.million_btu_per_hour
puts process_pressure.psig
puts process_pressure.kilopascal
puts steady_massflow.pounds_per_hour
coal=MaambaCoal.new(transport_distance: Length.kilometers(350))
puts (energy_flow/Dimensionless.percent(85)/coal.lhv).tonnes_per_hour
puts (energy_flow/Dimensionless.percent(85)*coal.energy_cost).dollars_per_month
puts (coal.unit_cost).dollars_per_tonne

puts MassValue.dollars_per_tonne(1).dollars_per_pound
puts EnergyValue.dollars_per_million_btu(8).dollars_per_kilowatt_hour