# encoding: utf-8

module Pulo

QuantityBuilder.build(:AngularVelocity) do
  dimensions T:-1
  si_unit :radian_per_second,:sf, 'rad.s⁻¹',1
  non_si_unit :rpm, :rpm, 'rpm', :radian_per_second, 60/(2*Math::PI)

end
#overide the standard methods for conversion between AngularVelocity and Frequency as it is not 1 to 1
  class AngularVelocity
    def frequency
      Frequency.hertz(self.radian_per_second.value/(Math::PI*2))
    end
  end
  class Frequency
    def angularvelocity
      AngularVelocity.radian_per_second(self.hertz.value*(Math::PI*2))
    end
  end

QuantityBuilder.build(:AngularAcceleration) do
  dimensions T:-2
  si_unit :radian_per_second_squared,:sf, 'rad.s⁻²',1
end

QuantityBuilder.build(:MomentOfInertia) do
  dimensions M:1,L:2
  si_unit :gram_meters_squared,:sf, 'g.m²',10**-3
  si_unit :kilogram_meters_squared,:sf, 'kg.m²',1
end

QuantityBuilder.build(:AngularMomentum) do
  dimensions M:1,L:2,T:-1
  si_unit :gram_meters_squared_per_second,:sf, 'g.m².s⁻¹',10**-3
  si_unit :kilogram_meters_squared_per_second,:sf, 'kg.m².s⁻¹',1
end

QuantityBuilder.build(:Torque) do
  dimensions M:1,L:2,T:-2

  si_unit :millinewton_meter,:s, 'mN.m',10**-3
  si_unit :newton_meter,:s, 'N.m',1
  si_unit :kilonewton_meter,:s, 'kN.m',10**3
  si_unit :meganewton_meter,:s, 'MN.m',10**6
end

end