QuantityBuilder.build(:Value) do
  dimensions V:1
  si_unit :dollar,:s, '$',1
  si_unit :cent,:s, 'c',10.0**-2

  synonyms :Cost, :Price
end
QuantityBuilder.build(:MassValue) do
  dimensions V:1,M:-1
  si_unit :dollar_per_gram,:sf, '$.g⁻¹',10.0**3
  si_unit :dollar_per_kilogram,:sf, '$.kg⁻¹',1
  si_unit :dollar_per_tonne,:sf, '$.t⁻¹',10.0**-3

  non_si_unit :dollar_per_pound,:sf,'$.lb⁻¹',:dollar_per_kilogram,2.20462
end
QuantityBuilder.build(:VolumeValue) do
  dimensions V:1,L:-3
  si_unit :dollar_per_cubic_meter,:sf, '$.m⁻³',1
  non_si_unit :dollar_per_litre,:sf,'$.lt⁻¹',:dollar_per_cubic_meter,10**-3
end
QuantityBuilder.build(:AreaValue) do
  dimensions V:1,L:-2
  si_unit :dollar_per_square_meter,:sf, '$.m⁻²',1
  non_si_unit :dollar_per_hectare,:sf,'$.ha⁻¹',:dollar_per_square_meter,10**4
end

QuantityBuilder.build(:ValueFlow) do
  dimensions V:1,T:-1
  si_unit :dollar_per_second,:sf, '$.s⁻¹',1
  si_unit :dollar_per_day,:sf, '$.dy⁻¹',1.0/(60*60*24)
  si_unit :dollar_per_month,:sf, '$.mnth⁻¹',1.0/(60*60*24*365/12)
  si_unit :dollar_per_year,:sf, '$.yr⁻¹',1.0/(60*60*24*365)
end
QuantityBuilder.build(:LengthValue) do
  dimensions V:1,L:-1
  si_unit :dollar_per_millimeter,:sf, '$.mm⁻¹',10.0**3
  si_unit :dollar_per_meter,:sf, '$.m⁻¹',1
  si_unit :dollar_per_kilometer,:sf, '$.km⁻¹',10.0**-3

  synonyms :TransportCost
end
QuantityBuilder.build(:SpecificLengthValue) do
  dimensions V:1,L:-1,M:-1
  si_unit :dollar_per_kilogram_meter,:sf, '$.m⁻¹.kg⁻¹',1
  si_unit :dollar_per_kilogram_kilometer,:sf, '$.km⁻¹.kg⁻¹',10.0**-3

  non_si_unit :dollar_per_tonne_kilometer,:sf,'$.t⁻¹.km⁻¹',:dollar_per_kilogram_kilometer,10**3
  synonyms :SpecificTransportCost
end
QuantityBuilder.build(:EnergyValue) do
  dimensions V:1,M:-1,L:-2,T:2
  si_unit :dollar_per_joule,:sf, '$.J⁻¹',1
  si_unit :dollar_per_megajoule,:sf, '$.MJ⁻¹',10**-6

  non_si_unit :dollar_per_kilowatt_hour,:sf, '$.kWh⁻¹',:dollar_per_megajoule,1.0/0.277777778
  non_si_unit :dollar_per_million_btu,:sf, '$.kWh⁻¹',:dollar_per_megajoule,1055.05585

  synonyms :EnergyCost
end
