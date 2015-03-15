require_relative '../../lib/pulo'

$precision=4
$significant=true
$no_quantity_names=true

irrigation_area=Area.hectares(450)
irrigation_demand=Precipitation.millimeters(850)
pump_station_cost=Cost.dollars(300000)

pipe=Pipeline.new(pipe: :class6_500,length: Length.kilometers(28), static_head: Height.meters(85))
pipe.flow=VolumeFlow.litres_per_second(irrigation_area.hectares.value)
lifts=(pipe.total_head.meters.value/60).ceil
capital_cost=pump_station_cost*lifts+pipe.cost
rate=0.08
periods=15
payment=(rate*capital_cost.value)/(1-(1+rate)**-periods)


pumping_efficiency=Dimensionless.percent(70)
energy_cost=EnergyValue.dollars_per_kilowatt_hour(0.05)
pumping_energy=pipe.hydraulic_power/pumping_efficiency
pump_cost=(
    pumping_energy*
    energy_cost/
    pipe.flow*
    irrigation_demand
    )
loan_per_hectare=(Value.dollars(payment)/irrigation_area)
total_per_hectare=loan_per_hectare+pump_cost

puts "Irrigation area: #{irrigation_area.hectares}"
puts "Irrigation demand (2 crop): #{irrigation_demand.millimeters}"
puts "Pipeline length: #{pipe.length.kilometers}"
puts "Pipeline cost: #{pipe.cost}"
puts "Pump station cost: #{pump_station_cost.dollars}"
puts "Water speed: #{pipe.flow_velocity.meters_per_second}"
puts "Static head: #{pipe.static_head.meters}"
puts "Friction head: #{pipe.friction_head.meters}"
puts "Total head: #{pipe.total_head.meters}"
puts "Pumping power: #{(pipe.hydraulic_power/pumping_efficiency).megawatts}"
puts "Pumping energy: #{(pumping_energy).kilowatt_hours_per_year}"
puts "Energy cost: #{energy_cost.dollars_per_kilowatt_hour}"
puts "Lifts: #{lifts}"
puts "Pipe cost: #{pipe.cost}"
puts "Total cost: #{capital_cost}"
puts "Capital cost: #{(capital_cost/irrigation_area).dollars_per_hectare}"

puts "Pipe loan repayment: #{Value.dollars(payment)}"
puts "Pipe loan repayment: #{loan_per_hectare.dollars_per_hectare}"

puts "Pump cost: #{pump_cost.dollars_per_hectare}"
puts "Total cost: #{total_per_hectare.dollars_per_hectare}"

