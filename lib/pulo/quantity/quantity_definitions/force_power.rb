# encoding: utf-8

module Pulo

QuantityBuilder.build(:Force) do
  dimensions M:1,L:1,T:-2

  si_unit :millinewton,:s, 'mN',10**-3
  si_unit :newton,:s, 'N',1
  si_unit :kilonewton,:s, 'kN',10**3
  si_unit :meganewton,:s, 'MN',10**6

  non_si_unit :pound_force,:pound_force, 'lbf',:newton,0.224808943
  non_si_unit :dyne,:dyne, 'dyn',:newton,10**5

end

QuantityBuilder.build(:Momentum) do
  dimensions M:1,L:1,T:-1

  si_unit :millinewton_second,:s, 'mN.s',10**-3
  si_unit :newton_second,:s, 'N.s',1
  si_unit :kilonewton_second,:s, 'kN.s',10**3
  si_unit :meganewton_second,:s, 'MN.s',10**6

end

QuantityBuilder.build(:Power) do
  dimensions M:1,L:2,T:-3

  si_unit :milliwatt,:s, 'mW',10**-3
  si_unit :watt,:s, 'W',1
  si_unit :kilowatt,:s, 'kW',10**3
  si_unit :megawatt,:s, 'MW',10**6
  si_unit :gigawatt,:s, 'GW',10**9


  non_si_unit :erg_per_second,:sf, 'erg.s⁻¹',:milliwatt,10000
  non_si_unit :btu_per_hour,:btu_per_hour,'Btu.hr⁻¹',:watt,3.41214163
  non_si_unit :foot_pound_per_minute,:foot_pounds_per_minute, 'ft.lb.min⁻¹',:watt,44.253729
  non_si_unit :horsepower,:horsepower, 'hp',:kilowatt,1.34102209
  non_si_unit :metric_horsepower,:metric_horsepower, 'mhp',:kilowatt,1.35962162
  non_si_unit :million_btu_per_hour,:sf,'MMBtu.hr⁻¹',:megawatt,3.41214163
  non_si_unit :gigawatt_hour_per_year,:gigawatt_hours_per_year, 'GW.hr.yr⁻¹',:gigawatt,24.0*365
  non_si_unit :kilowatt_hour_per_year,:kilowatt_hours_per_year, 'kW.hr.yr⁻¹',:kilowatt,24.0*365
  non_si_unit :kilowatt_hour_per_month,:kilowatt_hours_per_month, 'KW.hr.mnth⁻¹',:kilowatt,24.0*365/12
end
QuantityBuilder.build(:Pressure) do
  dimensions M:1,L:-1,T:-2

  si_unit :pascal,:s, 'Pa',1
  si_unit :kilopascal,:s, 'kPa',10**3
  si_unit :megapascal,:s, 'MPa',10**6

  non_si_unit :hectopascal,:s, 'hPa',:pascal,1.0/100
  non_si_unit :bar,:bar, 'bar',:kilopascal,0.01
  non_si_unit :millibar,:s, 'mbar',:pascal,0.01
  non_si_unit :torr,:torr, 'tor',:kilopascal,7.50061683
  non_si_unit :atmosphere,:s, 'atm',:megapascal,9.86923267
  non_si_unit :pounds_per_square_inch,:psia, 'psia',:kilopascal,0.145037738
  non_si_unit :pounds_per_square_inch_gauge,:psig, 'psig',:kilopascal,0.145037738
  non_si_unit :pound_per_square_foot,:sf, 'psf',:kilopascal,20.8854342
  non_si_unit :inch_of_mercury,:inches_of_mercury, 'inHg',:kilopascal,0.295333727
  non_si_unit :millimeter_of_mercury,:sf, 'mmHg',:kilopascal,7.50061683

  non_si_unit :megajoule_per_litre,:sf, 'MJ.lt⁻¹',:megapascal,10**-3
  non_si_unit :megajoule_per_hectolitre,:sf, 'MJ.hl⁻¹',:megapascal,10**-1

  synonyms :EnergyDensity, :VolumeEnergyDemand, :Stress, :TensileStrength, :YieldStrength
end
class Pressure
  class << self
    def psig(val)
      self.psia(val+14.7)
    end
  end
  def psig
    self.class.new(self.psia.value-14.7,:pounds_per_square_inch_gauge)
  end
end

end