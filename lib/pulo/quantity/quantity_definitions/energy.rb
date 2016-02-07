# encoding: utf-8

module Pulo

QuantityBuilder.build(:Energy) do
  dimensions M:1,L:2,T:-2

  si_unit :joule,:s, 'J',1
  si_unit :kilojoule,:s, 'kJ',10**3
  si_unit :megajoule,:s, 'MJ',10**6
  si_unit :gigajoule,:s, 'GJ',10**9

  non_si_unit :kilowatt_hour,:s, 'kWh',:megajoule,0.277777778
  non_si_unit :megawatt_hour,:s, 'MWh',:megajoule,0.000277777778
  non_si_unit :gigawatt_hour,:s, 'GWh',:gigajoule,0.000277777778
  non_si_unit :erg,:s, 'erg',:joule,10**7
  non_si_unit :calorie,:s, 'cal',:joule,0.239005736
  non_si_unit :kilocalorie,:s, 'kcal',:kilojoule,0.239005736
  non_si_unit :btu,:s, 'Btu',:megajoule,947.81712
  non_si_unit :million_btu,:million_btu, 'MMBtu',:gigajoule,947.81712/1000
  non_si_unit :therm,:s, 'thm',:gigajoule,947.81712/100
  non_si_unit :foot_pound,:s, 'ft.lb',:kilojoule,737.562149

  synonyms :Enthalpy
end
QuantityBuilder.build(:SpecificEnergy) do
  dimensions L:2,T:-2
  si_unit :joule_per_kilogram,:sf,'J.kg⁻¹',1
  si_unit :kilojoule_per_kilogram,:sf,'kJ.kg⁻¹',10**3
  si_unit :megajoule_per_kilogram,:sf,'MJ.kg⁻¹',10**6

  non_si_unit :megajoules_per_tonne,:sf,'MJ.t⁻¹',:megajoule_per_kilogram,1000
  non_si_unit :kilocalorie_per_kilogram,:sf,'kcal.kg⁻¹',:kilojoule_per_kilogram,0.239005736
  non_si_unit :btu_per_pound,:btu_per_pound,'Btu.lb⁻¹',:kilojoule_per_kilogram,0.429922614

  synonyms :SpecificEnthalpy,:CalorificValue,:HHV,:LHV
end
QuantityBuilder.build(:SpecificHeat) do
  dimensions L:2,T:-2,K:-1

  si_unit :joule_per_kilogram_kelvin,:sf, 'J.kg⁻¹.K⁻¹',1
  si_unit :kilojoule_per_kilogram_kelvin,:sf, 'kJ.kg⁻¹.K⁻¹',10**3
  si_unit :megajoule_per_kilogram_kelvin,:sf, 'MJ.kg⁻¹.K⁻¹',10**6

  non_si_unit :btu_per_pound_rankine,:btu_per_pound_rankine,'Btu.lb⁻¹.R⁻¹',:kilojoule_per_kilogram_kelvin,0.238845896627

  synonyms :SpecificEntropy,:SpecificHeatCapacity
end

end