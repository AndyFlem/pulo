# encoding: utf-8

module Pulo
QuantityBuilder.build(:Dimensionless) do
  dimensions L:0
  si_unit :n,:n, '',1
  si_unit :percent,:percent, 'pct',0.01
  synonyms :Efficiency,:Ratio,:Factor,:Count
end
QuantityBuilder.build(:Angle) do
  dimensions L:0
  si_unit :radian,:radians,'rad',1
  non_si_unit :degree,:s, 'deg',:radian,360.0/(2*Math::PI)

  constant :pi, 'pi',:radian,Math::PI
end
QuantityBuilder.build(:Length) do
  dimensions L:1
  si_unit :meter,:s, 'm',1.0
  si_unit :centimeter,:s, 'cm',10.0**-2
  si_unit :kilometer,:s, 'km',10**3
  si_unit :millimeter,:s, 'mm',10.0**-3
  si_unit :micrometer,:s, 'um',10.0**-6
  si_unit :nanometer,:s, 'nm',10.0**-9

  non_si_unit :mile,:s, 'mi',:kilometer,1.0/1.609344
  non_si_unit :yard,:s, 'yd',:meter,1.09361
  non_si_unit :foot,:feet, 'ft',:meter,1/0.3048
  non_si_unit :inch,:inches, 'in',:millimeter,1.0/25.4
  non_si_unit :thou,:thou, 'th',:millimeter,1.0/0.0254

  non_si_unit :chain,:s, 'ch',:meter,1.0/20.1168
  non_si_unit :furlong,:s, 'fu',:kilometer,1.0/0.201168

  non_si_unit :astronomical_unit,:s, 'AU',:kilometer,149597870.7
  non_si_unit :parsec,:s, 'pc',:kilometer,3.0856776*10**13
  non_si_unit :lightyear,:s, 'ly',:kilometer,9.4607**10**13

  non_si_unit :fathom, :s, 'fth',:meter,0.546806649
  non_si_unit :cable, :s, 'cbl',:kilometer,1000.0/185.2
  non_si_unit :nautical_mile, :s, 'nm',:kilometer,1000.0/1852

  synonyms :Width,:Depth,:Height,:Head,:Distance,:Displacement,:Precipitation
end

QuantityBuilder.build(:Duration) do
  dimensions T:1

  si_unit :day,:s, 'dy',3600*24
  si_unit :hour,:s, 'hr',3600
  si_unit :minute,:s, 'min',60
  si_unit :second,:s, 'sec',1
  si_unit :millisecond,:s, 'ms',10.0**-3
  si_unit :microsecond,:s, 'μs',10.0**-6
  si_unit :nanosecond,:s, 'ns',10.0**-9

  non_si_unit :year,:s, 'yr',:day,1.0/365
  non_si_unit :month,:s, 'mnth',:day,1.0/(365.0/12)
  non_si_unit :week,:s, 'wk',:day,1.0/7


  synonyms :Period, :Timing, :Interval
end

QuantityBuilder.build(:Frequency) do
  dimensions T:-1
  si_unit :hertz,:hertz, 'Hz',1
  si_unit :kilohertz,:kilohertz, 'kHz',10**3
  si_unit :megahertz,:megahertz, 'MHz',10**6

  non_si_unit :percent_per_year,:percent_per_year, 'pct.yr⁻¹',:hertz,(60*60*24*365)*100
  non_si_unit :percent_per_month,:percent_per_month, 'pct.mnt⁻¹',:hertz,(60*60*24*365)*100/12

  synonyms :InterestRate
end

QuantityBuilder.build(:Mass) do
  dimensions M:1
  si_unit :tonne,:s, 't',10**3
  si_unit :kilogram, :s, 'kg',1
  si_unit :gram, :s, 'g',10**-3
  si_unit :milligram, :s, 'mg',10**-6
  si_unit :microgram, :s, 'μg',10**-9

  non_si_unit :grain,:s, 'gr',:gram,15.4323584
  non_si_unit :drachm,:s, 'dr',:gram,0.56438339119727
  non_si_unit :ounce,:s, 'oz',:gram,0.035274
  non_si_unit :pound,:s, 'lb',:kilogram,2.20462
  non_si_unit :stone,:stone, 'st',:kilogram,0.157473
  non_si_unit :quarter,:s, 'qr',:kilogram,0.078736522

  non_si_unit :hundredweight,:s, 'cwt',:tonne,0.050802345
  non_si_unit :short_ton,:s, 'short ton',:tonne,1.10231
  non_si_unit :long_ton,:s, 'long ton',:tonne,0.984207

  non_si_unit :solar_unit,:s, 'Mo',:kilogram,1.0/(1.98855*10**30)

  synonyms :Weight,:Heft
end

QuantityBuilder.build(:Temperature) do
  dimensions K:1

  si_unit :kelvin,:kelvin, 'K',1

  non_si_unit :celsius,:degrees_celsius, '°C',:kelvin,1
  non_si_unit :fahrenheit,:degrees_fahrenheit, '°F',:kelvin,5.0/9

end
class Temperature
  def kelvin
    case self.unit.name
      when :kelvin
        self
      when :celsius
        self.class.new(self.value+273.15,:kelvin)
      when :fahrenheit
        self.class.new((5.0/9.0*(self.value-32.0))+273.15,:kelvin)
    end
  end
  def celsius
    case self.unit.name
      when :celcius
        self
      when :kelvin
        self.class.new(self.value-273.15,:celsius)
      when :fahrenheit
        self.class.new((5.0/9.0*(self.value-32.0)),:celsius)
    end
  end
  def fahrenheit
    case self.unit.name
      when :fahrenheit
        self
      when :celsius
        self.class.new((9.0/5.0*self.value)+32.0,:fahrenheit)
      when :kelvin
        self.class.new((9.0/5.0*(self.value-273.15))+32.0,:fahrenheit)
    end
  end
end

end