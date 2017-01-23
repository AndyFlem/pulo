require_relative '../lib/pulo'

module Pulo

  #spinning fly wheel

  radius=Length.meters(1.0)
  thickness=Length.meters(0.7)
  figure=Cylinder.new(radius: radius,length: thickness)
  mass=figure.volume*Densities.Steel
  inertia=MomentOfInertia.disc(mass,radius)
  rotation=AngularVelocity.rpm(5000)
  momentum=inertia*rotation
  energy=0.5*momentum*rotation
  period=1/rotation.frequency
  edge_veloicty=figure.face.perimeter/period
  hoop_stress=Densities.Steel*radius**2*rotation**2
  diesel_equivalent=(energy/SpecificEnergies.Diesel/Densities.Diesel).litres

  puts radius,thickness,figure,mass.kilogram,inertia,rotation,momentum,energy.megajoules,period,edge_veloicty.kilometers_per_hour
  puts "Hoop stress at rim: #{hoop_stress.to_s}"
  puts "!Hoop stress exceeds yield strength of Steel_high_strength_alloy (#{YieldStrengths.Steel_high_strength_alloy}) !" if hoop_stress>YieldStrengths.Steel_high_strength_alloy
  puts "Energy equivalent in diesel: #{diesel_equivalent.to_s}"

end