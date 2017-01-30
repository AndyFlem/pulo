# encoding: utf-8

module Pulo
QuantityBuilder.build(:Velocity) do
  dimensions L:1,T:-1
  si_unit :kilometer_per_second,:sf, 'km.s⁻¹',10**3
  si_unit :meter_per_second,:sf, 'm.s⁻¹',1.0
  si_unit :kilometer_per_hour,:sf, 'km.hr⁻¹',1000.0/3600.0
  si_unit :meter_per_hour,:sf, 'm.hr⁻¹',1.0/3600.0

  non_si_unit :mile_per_hour,:sf, 'ml.hr⁻¹',:kilometer_per_hour,0.621371
  non_si_unit :millimeter_per_hour,:sf, 'mm.hr⁻¹',:kilometer_per_hour,10**6


  constant :speed_of_light, 'c',:meter_per_second,299792458
  constant :speed_of_sound, 'c',:meter_per_second,343.2

  synonyms :Speed
end

QuantityBuilder.build(:Acceleration) do
  dimensions L:1,T:-2

  si_unit :meter_per_second_squared,:sf, 'm.s⁻²',1
  non_si_unit :foot_per_second_squared,:feet_per_second_squared, 'ft.s⁻²',:meter_per_second_squared,3.2808399

  constant :standard_gravity, 'g',:meter_per_second_squared,9.80665
end

QuantityBuilder.build(:MassFlow) do
  dimensions M:1,T:-1
  si_unit :kilogram_per_second,:sf, 'kg.s⁻¹',1
  si_unit :gram_per_second,:sf, 'g.s⁻¹',10**-3

  non_si_unit :tonne_per_year,:sf, 't.yr⁻¹',:kilogram_per_second,60.0*60*24*365/1000
  non_si_unit :tonne_per_month,:sf, 't.mnth⁻¹',:kilogram_per_second,60.0*60*24*365/12/1000
  non_si_unit :tonne_per_day,:sf, 't.dy⁻¹',:kilogram_per_second,60.0*60*24/1000
  non_si_unit :tonne_per_hour,:sf, 't.hr⁻¹',:kilogram_per_second,60.0*60/1000
  non_si_unit :pound_per_second,:sf, 'lb.s⁻¹',:kilogram_per_second,2.20462262
  non_si_unit :slug_per_second,:sf, 'slug.s⁻¹',:kilogram_per_second,0.0685217659
  non_si_unit :pound_per_hour,:sf, 'lb.hr⁻¹',:kilogram_per_second,2.20462262*60*60


  synonyms :MassFlux
end

QuantityBuilder.build(:VolumeFlow) do
  dimensions L:3,T:-1
  si_unit :cubic_meter_per_year,:cubic_meters_per_year, 'm³.yr⁻¹',1.0/(3600*24*365)
  si_unit :cubic_meter_per_day,:cubic_meters_per_day, 'm³.day⁻¹',1.0/(3600*24)
  si_unit :cubic_meter_per_hour,:cubic_meters_per_hour, 'm³.hr⁻¹',1.0/3600
  si_unit :cubic_meter_per_second,:cubic_meters_per_second, 'cumec',1
  si_unit :cubic_centimeter_per_second,:cubic_centimeters_per_second, 'cm³.s⁻¹',10**-6

  non_si_unit :litre_per_second,:sf, 'lt.s⁻¹',:cubic_meter_per_second,10**3
  non_si_unit :litre_per_hour,:sf, 'lt.hr⁻¹',:cubic_meter_per_hour,10**3
  non_si_unit :megalitre_per_hour,:sf, 'Mlt.hr⁻¹',:cubic_meter_per_hour,10**-3
  non_si_unit :cubic_foot_per_second,:cubic_feet_per_second, 'cusec',:cubic_meter_per_second,35.3146667
  non_si_unit :gallon_per_second,:sf, 'gal.s⁻¹',:cubic_meter_per_second,264.172052

  non_si_unit :hectolitre_per_year,:sf,'hl.yr⁻¹',:cubic_meter_per_year,10

  synonyms :Discharge, :Flow
end

end