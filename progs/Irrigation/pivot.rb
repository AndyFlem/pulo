require_relative '../../lib/pulo'

$precision=4
$significant=true
$no_quantity_names=false
$quantity_group=QuantityGroups::IRRIGATION

pivot=Circle.new(area: Area.hectares(80))
application_rate=Depth.millimeters(10)/Period.hours(22)
flow=application_rate*pivot.area
puts "Pivot area: #{pivot.area}"
puts "Pivot radius: #{pivot.radius}"
puts "Application rate: #{application_rate}"
puts "Flow: #{flow}"

puts (Head.meters(10)*
    VolumeFlow.cumec(1.5)*
    Acceleration.g*
    Density.water*
    Efficiency.percent(90)
).kilowatt_hours_per_year.to_s