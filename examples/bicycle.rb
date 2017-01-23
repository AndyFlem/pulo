#Based on: https://physicstasks.eu/280/bicyclist-going-uphill

# A bicyclist is going up a 5% slope by a uniform speed of 27 km·h-1.
# The magnitude of the air resistance force is given by Fres = 0.5.density*k*v2*x-sectional area where the numerical value of {k} = 0.5.
# The mass of the bicyclist including the bike is 70 kg. Do not consider the rolling resistance.

# What forward force exerted on the bike by the road is needed to make the bicyclist move with constant speed?
# How much work does the bicyclist do when riding a distance of 1200 m? What is the power of the bicyclist during the ride?
# Assume there is no loss of mechanical energy.

require_relative '../lib/pulo'

module Pulo
  speed=Speed.kilometers_per_hour(27)
  mass=Mass.kilograms(70)
  drag_coeff=Dimensionless.n(0.5)
  x_area=Area.square_meters(1)
  angle=Angle.percent(5)
  dist=Length.meters(1200)

  f_air=0.5*drag_coeff*speed**2*x_area*Densities.Air

  f_mass=mass*Acceleration.g*Math.sin(angle)

  f_net=f_air+f_mass

  work=f_net*dist
  power=f_net*speed

  puts speed,mass,drag_coeff,x_area,f_air,angle,f_mass,f_net,work.kilojoules,power.watts

end
