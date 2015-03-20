# encoding: utf-8

require 'spec_helper'

module Pulo

describe 'Saturated Steam temperature and pressure' do
  it 'should give the pressure of sat steam given temp' do
    expect((WaterSteam.new(temperature: Temperature.kelvin(300)).pressure.kilopascals).to_s).to eq("Pressure: 3.54 kPa")
  end
  it 'should give the temp of sat steam given pressure' do
    expect((WaterSteam.new(pressure: Pressure.megapascals(1)).temperature).to_s).to eq("Temperature: 453.04 K")
  end
  it 'should give other props for temp and pressure' do
    w=WaterSteam.new(pressure: Pressure.megapascals(0.0035), temperature: Temperature.kelvin(300))
    expect((w.if97_region).to_s).to eq("2")
    expect((w.specific_volume).to_s).to eq("SpecificVolume: 39.49 m\u00B3.kg\u207B\u00B9")
  end
  it 'should give other props for temp and pressure' do
    expect((WaterSteam.new(pressure: Pressure.megapascals(3), temperature: Temperature.kelvin(300)).specific_internal_energy).to_s).to eq("SpecificEnergy: 0.11 MJ.kg\u207B\u00B9")
  end
  it 'should give other props for temp and pressure' do
    expect((WaterSteam.new(pressure: Pressure.megapascals(80), temperature: Temperature.kelvin(300)).specific_entropy).to_s(6)).to eq("SpecificHeat: 0.368564 kJ.kg\u207B\u00B9.K\u207B\u00B9")
  end
  it 'should give other props for temp and pressure' do
    expect((WaterSteam.new(pressure: Pressure.megapascals(3), temperature: Temperature.kelvin(300)).specific_enthalpy).to_s).to eq("SpecificEnergy: 0.12 MJ.kg\u207B\u00B9")
  end
  it 'should give other props for pressure and specific entropy' do
    w=WaterSteam.new(pressure: Pressure.megapascals(50), specific_entropy: SpecificEntropy.kilojoules_per_kilogram_kelvin(5.5))
    expect((w.temperature).to_s).to eq("Temperature: 813.88 K")
  end
  it 'should give other props for pressure and specific enthalpy (r1)' do
    w=WaterSteam.new(pressure: Pressure.megapascals(80), specific_enthalpy: SpecificEnthalpy.kilojoules_per_kilogram(500))
    expect((w.temperature).to_s).to eq("Temperature: 378.11 K")
  end
  it 'should give temp for pressure and specific enthalpy (r2a)' do
    w=WaterSteam.new(pressure: Pressure.megapascals(0.001), specific_enthalpy: SpecificEnthalpy.kilojoules_per_kilogram(3000))
    expect((w.temperature).to_s).to eq("Temperature: 534.43 K")
  end
end

#p Pressure.bar(5).psi.to_s
#p Temperature.fahrenheit(298).celsius.to_s
#p MassFlow.pounds_per_hour(21500).kilograms_per_second.to_s
#p (Power.millions_btu_per_hour(26.7).megawatts*Dimensionless.percent(6.4)).to_s

end