# encoding: utf-8

module Pulo

  class Water
  #def self.bulk_modulus
    #BulkModulus.new(2.15*10**9)
  #end
  #def self.expansion_coefficient
  #  Dimensionless.n(0.000088)
  #end
  #def self.enthalpy_of_vaporization
  #  40680
  #end
  def self.standard_density
    Density.kilograms_per_cubic_meter(1000)
  end
  #def self.density(temperature,pressure)
  #  tmp=temperature.is_a?(Temperature) ? temperature.value : temperature
  #  pres=pressure.is_a?(Pressure) ? pressure.value : pressure
  #  Density.new(999.8 / (1 + Water.expansion_coefficient * tmp) / (1 - (pres - 1105) / Water.bulk_modulus.value))
  #end
  #def self.boiling_point(pressure)
  #  pres=pressure.is_a?(Pressure) ? pressure.value : pressure
  #  k=GAS_CONSTANT/Water.enthalpy_of_vaporization
  #  Temperature.new(1/((1/Temperature.new(100).kelvin)-k*Math.log(pres/Atmosphere.standard_pressure.value)),:kelvin)
  #end
  #def self.melting_point(pressure)
  #  pres=pressure.is_a?(Pressure) ? pressure.value : pressure
  #  Temperature.new(Math::E**(Math.log(Temperature.new(0).kelvin)+((-1.56*10**-6)/6030)*(pres-Atmosphere.standard_pressure.value)),:kelvin)
  #end
  end

end