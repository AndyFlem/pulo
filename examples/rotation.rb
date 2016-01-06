require_relative '../lib/pulo'

module Pulo

  #spinning fly wheel

  radius=Length.centimeters(20)
  thickness=Length.millimeters(15)
  figure=Cylinder.new(radius: radius,length: thickness)
  mass=figure.volume*Densities.Steel
  inertia=MomentOfInertia.disc(mass,radius)
  rotation=Frequency.hertz()

  puts radius,thickness,figure,mass.kilogram,inertia

end