# encoding: utf-8

require_relative '../../spec/spec_helper'

module Pulo


describe 'Creating quantities' do
  it 'should create SI quantity from a full name' do
    expect(Length.kilometer(10).to_s).to eq('Length: 10 km')
  end
  it 'should create non-SI quantity from a full name' do
    expect(Length.inch(10).to_s).to eq('Length: 10 in')
  end
  it 'should create SI quantity from a full plural name' do
    expect(Length.kilometers(10).to_s).to eq('Length: 10 km')
  end
  it 'should create non-SI quantity from a full plural name' do
    expect(Length.inches(10).to_s).to eq('Length: 10 in')
  end
  it 'should create SI quantity from abbreviation' do
    expect(Length.cm(10).to_s).to eq('Length: 10 cm')
  end
  it 'should create non-SI quantity from abbreviation' do
    expect(Length.in(10).to_s).to eq('Length: 10 in')
  end
end
describe 'Creating quantities by synonym' do
  it 'should create SI quantity from a synonym' do
    expect(Depth.kilometer(10).to_s).to eq('Depth: 10 km')
  end
end

describe 'Comparing quantities' do
  it 'equality of different units' do
    expect(Depth.kilometer(1)==Length.meters(1000)).to eq(true)
  end
  it 'greater than of different units' do
    expect(Depth.kilometer(1)<Length.meters(2000)).to eq(true)
  end
  it 'less than of different units' do
    expect(Depth.kilometer(2)>Length.meters(1000)).to eq(true)
  end
end

describe 'Converting quantities' do
  it 'should convert from SI to SI' do
    expect(Timing.seconds(3600).hours.to_s).to eq('Timing: 1 hr')
  end
  it 'should convert from SI to SI' do
    expect(Length.kilometers(-10.32).meters.to_s).to eq('Length: -10,320 m')
  end
  it 'should convert from SI to non-SI' do
    expect(Length.kilometers(1).inches.to_s).to eq('Length: 39,370.08 in')
  end
  it 'should convert from SI to non-SI' do
    expect(Length.meters(1).feet.to_s).to eq('Length: 3.28 ft')
  end
  it 'should convert from non-SI to SI' do
    expect(Length.feet(1).centimeters.to_s).to eq('Length: 30.48 cm')
  end
  it 'should convert from non-SI to non-SI' do
    expect(Length.feet(1).inches.to_s).to eq('Length: 12 in')
  end
  it 'should convert from non-SI to non-SI' do
    expect(Pressure.hectopascal(1).in.mmHg.to_s).to eq('Pressure: 0.75 mmHg')
  end
end

describe 'Scalar functions' do
  it 'should assume addition is of the same unit' do
    expect((Length.foot(1)+1.1).to_s).to eq('Length: 2.1 ft')
  end
  it 'should assume negation is of the same unit' do
    expect((Length.meters(1)-1.1).to_s).to eq('Length: -0.1 m')
  end
  it 'should assume multiplication is scalar' do
    expect((Length.meters(10)*2).to_s).to eq('Length: 20 m')
  end
  it 'should assume division is scalar' do
    expect((Length.inches(10)/2).to_s).to eq('Length: 5 in')
  end
end
describe 'Convert to base unit' do
  it 'should assume convert an SI to its base unit' do
    expect((Length.centimeters(200).to_base_unit).to_s).to eq('Length: 2 m')
  end
  it 'should assume convert an non-SI to its base unit' do
    expect((Length.inches(200).to_base_unit).to_s).to eq('Length: 5.08 m')
  end
end

describe 'Rescaling' do
  it 'should rescale SI units' do
    expect((Length.centimeters(2040).rescale).to_s).to eq('Length: 20.4 m')
  end
  it 'should rescale non-SI units (with conversion to SI' do
    expect((Length.inches(2040).rescale).to_s).to eq('Length: 51.82 m')
  end
end

describe 'Non-si to SI convert' do
  it 'should assume convert an non-SI to its natural SI equivalent' do
    expect((Length.inches(2).to_si).to_s).to eq('Length: 50.8 mm')
  end
  it 'should assume convert an non-SI to its natural SI equivalent' do
    expect((Length.chains(2).to_si).to_s).to eq('Length: 40.23 m')
  end
end

describe 'Constants' do
  it 'should know the speed of light' do
    expect(Velocity.speed_of_light.to_s).to eq('Velocity: 299,792,458 m.s⁻¹')
  end

end

describe 'Dimensions' do
  it 'should multiply same dimensions for square' do
    expect((Length.inches(1005)*Length.meters(1005)).hectares.to_s).to eq('Area: 2.57 ha')
  end
  it 'again for cube' do
    expect((Length.millimeters(1)*Length.millimeters(0.21)*Length.centimeters(1.2)).to_s).to eq('Volume: 2.52 mm³')
  end
  it 'length, time and speed' do
    expect((Length.kilometers(2)/Interval.hour(1)).kilometers_per_hour.to_s).to eq('Velocity: 2 km.hr⁻¹')
  end
  it 'should build intermediate quantities' do
    #specific_value :kilowatt_hours,0.07

    expect(
        (Head.centimeters(1000)*
            VolumeFlow.cumec(150)*
            Acceleration.g*
            Density.water*
            Efficiency.percent(90)
      ).gigawatt_hours_per_year.to_s
    ).to eq("Power: 115.97 GW.hr.yr\u207B\u00B9")
  end

end

describe 'Fixnum overloads for multiplication' do
  it 'should deal with fixnum * quantity' do
    expect((2*Area.square_meters(2)).to_s).to eq('Area: 4 m²')
  end
  it 'should deal with float * quantity' do
    expect((4.4*Area.square_meters(2)).to_s).to eq('Area: 8.8 m²')
  end
  it 'should deal with bignum * quantity' do
    expect((10**10*Area.square_meters(2)).to_s).to eq('Area: 20,000,000,000 m²')
  end
end

describe 'Non standard conversions' do
  it 'should convert celsius to kelvin' do
    expect(Temperature.celsius(100).kelvin.to_s).to eq('Temperature: 373.15 K')
  end
  it 'should convert celsius to fahrenheit' do
    expect(Temperature.celsius(37).fahrenheit.to_s).to eq('Temperature: 98.6 °F')
  end
  it 'should convert fahrenheit to celsius' do
    expect(Temperature.fahrenheit(98.6).celsius.to_s).to eq('Temperature: 37 °C')
  end
  it 'should convert fahrenheit to kelvin' do
    expect(Temperature.fahrenheit(98.6).kelvin.to_s).to eq('Temperature: 310.15 K')
  end
  it 'should convert kelvin to celsius' do
    expect(Temperature.kelvin(373.15).celsius.to_s).to eq('Temperature: 100 °C')
  end
  it 'should convert kelvin to fahrenheit' do
    expect(Temperature.kelvin(273.15+37).fahrenheit.to_s).to eq('Temperature: 98.6 °F')
  end
end
describe 'Inverse' do
  it 'should inverse a period to a frequency' do
    expect(Period.seconds(0.5).inverse.to_s).to eq('Frequency: 2 Hz')
  end
end
describe 'Fixnum overloads for division' do
  it 'should deal with fixnum / quantity' do
    expect((5/Period.seconds(2)).to_s).to eq('Frequency: 2.5 Hz')
  end
  it 'should deal with float * quantity' do
    expect((5.0/Period.seconds(2)).to_s).to eq('Frequency: 2.5 Hz')
  end
  it 'should deal with bignum * quantity' do
    expect((10**10/Area.square_centimeters(2)).to_s).to eq('L_2: 5,000,000,000 L⁻²*10^4.0')
  end
end

describe 'Quantity adding and minusing' do
  it 'should deal with quantity + quantity' do
    expect((Volume.cubic_meters(2)+Volume.cubic_meters(3)).to_s).to eq('Volume: 5 m³')
  end
  it 'should deal with quantity + quantity including unit change' do
    expect((Volume.cubic_meters(2)+Volume.cubic_meters(3).cubic_feet).to_s).to eq('Volume: 5 m³')
  end
  it 'should deal with quantity - quantity' do
    expect((Volume.cubic_meters(4)-Volume.cubic_meters(3)).to_s).to eq('Volume: 1 m³')
  end
  it 'should deal with quantity - quantity including unit change' do
    expect((Volume.cubic_meters(4)-Volume.cubic_meters(3).cubic_feet).to_s).to eq('Volume: 1 m³')
  end
end

describe 'Some errors' do
  it 'should not allow addition of quantities with different dimensions' do
    expect{Volume.cubic_meters(4)+Length.meters(3)}.to raise_error(QuantitiesException)
  end
  it 'should not allow minusing of quantities with different dimensions' do
    expect{Volume.cubic_meters(4)-Length.meters(3)}.to raise_error(QuantitiesException)
  end
  it 'should not allow multiplying of quantities with non quantities' do
    expect{Volume.cubic_meters(4)*"l"}.to raise_error(QuantitiesException)
  end
  it 'should not allow dividing of quantities with non quantities' do
    expect{Volume.cubic_meters(4)/"l"}.to raise_error(QuantitiesException)
  end
end

describe 'Raising quantities to a power' do
  it 'should allow squaring a quantity' do
    expect((Length.meters(2)**2).to_s).to eq('Area: 4 m²')
  end
  it 'should allow cubing a quantity' do
    expect((Length.meters(2)**3).to_s).to eq('Volume: 8 m³')
  end
end
describe 'Roots of quantities' do
  it 'should allow for square root of a quantity' do
    expect((Area.square_meters(4).rt(2)).to_s).to eq('Length: 2 m')
  end
  it 'should allow cubing a quantity' do
    expect((Volume.cubic_meters(8).rt(3)).to_s).to eq('Length: 2 m')
  end
end

describe 'Quantities with same dimensions' do
  it 'should default to energy in jules for force*distance' do
    expect((Force.newtons(2)*Displacement.meters(2)).to_s).to eq('Energy: 4 J')
  end
  it 'should allow force*distance to be given as torque in Nm' do
    expect((Force.newtons(2)*Displacement.meters(2)).torque.to_s).to eq('Torque: 4 N.m')
  end
  it '(and the reverse of) should allow force*distance to be given as torque in Nm' do
    expect((Force.newtons(2)*Displacement.meters(2)).torque.energy.to_s).to eq('Energy: 4 J')
  end
end
describe 'Special handling of psia/psig' do
  it 'should implicitly convert psig to psia' do
    expect((Pressure.psig(0)).to_s).to eq ("Pressure: 14.7 psia")
  end
  it 'should allow convert psia to psig' do
    expect((Pressure.psia(14.7).psig).to_s).to eq ("Pressure: 0 psig")
  end
end

describe 'Synonyms should still allow math and comparison' do
  it 'should see SpecificEnergy and SpecificEnthalpy as equivalent' do
    expect(((SpecificEnthalpy.joules_per_kilogram(1)+SpecificEnergy.joules_per_kilogram(1))==SpecificEnergy.joules_per_kilogram(2)).to_s).to eq ("true")
  end
end

describe 'Angles should be as expected' do
  it 'should allow degrees and radians to equate' do
    expect((Angle.radians(Math::PI)*2==Angle.degrees(360)).to_s).to eq ("true")
  end
  it 'should do cos on Angles' do
    expect(Math.cos(Angle.degrees(360)).to_s).to eq ("1 ")
  end
  it 'should do sin on Angles' do
    expect(Math.sin(Angle.degrees(360)).to_s).to eq ("0 ")
  end
end

describe 'Formatting' do
  it 'should handle sig figs and precision' do
    Pulo.significant_figures=true;
    Pulo.precision=6;

    expect((Length.chains(2).to_si).to_s).to eq('Length: 40.2336 m')
    Pulo.significant_figures=false;
    Pulo.precision=2;
  end

  it 'should allow output without quantity names' do
    Pulo.supress_quantity_names=true;
    expect((Length.chains(2).to_si).to_s).to eq('40.23 m')
    Pulo.supress_quantity_names=false;
  end

  it 'should handle zero' do
    expect((Length.meters(0.0)).to_s).to eq('Length: 0 m')
  end

end

end
