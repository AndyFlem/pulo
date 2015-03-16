# encoding: utf-8


QuantityBuilder.build(:Area) do
  dimensions L:2

  si_unit :square_kilometer,:s, 'km²',10**6
  si_unit :square_meter,:s, 'm²',1
  si_unit :square_centimeter,:s, 'cm²',10**-4
  si_unit :square_millimeter,:s, 'mm²',10**-6
  si_unit :square_micrometer,:s, 'μm²',10**-12
  si_unit :square_nanometer,:s, 'nm²',10**-18

  non_si_unit :hectare,:s, 'ha',:square_meters,1.0/10000

  non_si_unit :acre,:s, 'ac',:square_kilometer,247.105
  non_si_unit :square_mile,:s, 'mi²',:square_kilometer,0.386102
  non_si_unit :square_yard,:s, 'yd²',:square_meter,1.19599
  non_si_unit :square_foot,:square_feet, 'ft²',:square_meter,10.7639
  non_si_unit :square_inch,:square_inches, 'in²',:square_centimeter,0.15500031

  synonyms :Extent
end

QuantityBuilder.build(:Volume) do
  dimensions L:3

  si_unit :cubic_kilometer,:s, 'km³',10**9
  si_unit :cubic_meter,:s, 'm³',1
  si_unit :cubic_centimeter,:s, 'cm³',10**-6
  si_unit :cubic_millimeter,:s, 'mm³',10**-9
  si_unit :cubic_micrometer,:s, 'μm³',10**-18
  si_unit :cubic_nanometer,:s, 'nm³',10**-27

  non_si_unit :megalitre,:s, 'Mlt',:cubic_meter,10.0**-3
  non_si_unit :litre,:s, 'lt',:cubic_meter,10.0**3
  non_si_unit :hectolitre,:s, 'hl',:cubic_meter,10.0
  non_si_unit :millilitre,:s, 'ml',:cubic_centimeter,1

  non_si_unit :cubic_mile,:s, 'mi³',:cubic_kilometer,0.239912759
  non_si_unit :cubic_yard,:s, 'yd³',:cubic_meter,1.30795062
  non_si_unit :cubic_foot,:cubic_feet, 'ft³',:cubic_meter,35.3147
  non_si_unit :cubic_inch,:cubic_inches, 'in³',:cubic_centimeter,0.0610237441

  non_si_unit :gallon,:s, 'gal',:cubic_meter,264.172
  non_si_unit :pint,:s, 'pint',:cubic_meter,2113.38
  non_si_unit :beer_barrel,:s,'bbl',:cubic_meter,10.0**3/117

  synonyms :Capacity
end
QuantityBuilder.build(:Density) do
  dimensions M:1,L:-3
  si_unit :kilogram_per_cubic_meter,:sf, 'kg.m⁻³',1
  si_unit :gram_per_cubic_centimeter,:sf, 'g.cm⁻³',10**3

  non_si_unit :ounce_per_cubic_inch,:sf, 'oz.in⁻³',:gram_per_cubic_centimeter,0.578036672
  non_si_unit :pound_per_cubic_foot,:sf, 'lb.ft⁻³',:kilogram_per_cubic_meter,0.0624279606
  non_si_unit :pound_per_cubic_yard,:sf, 'lb.yd⁻³',:kilogram_per_cubic_meter,1.68555494
  non_si_unit :pound_per_gallon,:sf, 'lb.gal⁻¹',:kilogram_per_cubic_meter,0.00834540445

  constant :water, '',:kilogram_per_cubic_meter,1000
end
QuantityBuilder.build(:SpecificVolume) do
  dimensions M:-1,L:3
  si_unit :cubic_meter_per_kilogram,:cubic_meters_per_kilogram, 'm³.kg⁻¹',1
  si_unit :cubic_centimeter_per_kilogram,:cubic_centimeters_per_kilogram, 'cm³.kg⁻¹',10**-6
  non_si_unit :cubic_foot_per_pound,:cubic_feet_per_pound, 'ft³.lb⁻¹',:cubic_meter_per_kilogram,16.0184634
end