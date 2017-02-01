# encoding: utf-8

require_relative '../../spec/spec_helper'

module Pulo
  describe 'Math operations on quantities' do
    before do
      @dimless = Dimensionless.percent(50)
      @dimless2 = Dimensionless.n(0.5)
      @int=Length.inches(4)
      @float=Volume.cubic_meters(10.10)
      @bigdec=Area.square_inches(BigDecimal(9.9,4))
      @bignum=Volume.litres(1234567890 ** 2 )
      @angle=Angle.degrees(90)
      @angle2=Angle.degrees(45)
    end
    it 'should allow unary negation' do
      expect((-@angle).to_s).to eq("Angle: -90 deg")
    end
    it 'should allow Math.sqrt and Quantity.rt()' do
      expect((Math.sqrt(@bigdec).inches).to_s).to eq("Length: 3.15 in")
      expect((@bignum.rt(3)).to_s).to eq("Length: 115.08 km")
    end
    it 'should allow trigonometric functions on angles' do
      expect(Math.cos(@angle).to_s).to eq("0 ")
      expect(Math.sin(@angle).to_s).to eq("1 ")
      expect(Math.tan(@angle2).to_s).to eq("1 ")
    end
    it 'should allow reverse trigonometric functions on dimensionless' do
      expect(Math.acos(@dimless2).to_s).to eq("Angle: 1.05 rad")
      expect(Math.asin(@dimless2).to_s).to eq("Angle: 0.52 rad")
      expect(Math.atan(@dimless2).to_s).to eq("Angle: 0.55 rad")
    end
    it 'should allow scalar+dimensionless' do
      expect((10+Dimensionless.n(10)).to_s).to eq("20 ")
      expect((10.1+Dimensionless.percent(10)).to_s).to eq("10.2 ")
      expect((BigDecimal(10.1,3)+Dimensionless.percent(10)).to_s).to eq("10.2 ")
      expect(((10000000**2)+Dimensionless.n(10)).to_s).to eq("100,000,000,000,010 ")
    end
    it 'should allow scalar-dimensionless' do
      expect((10-Dimensionless.n(1)).to_s).to eq("9 ")
      expect((10.1-Dimensionless.percent(10)).to_s).to eq("10 ")
      expect((BigDecimal(10.1,3)-Dimensionless.percent(10)).to_s).to eq("10 ")
      expect(((10000000**2)-Dimensionless.n(10)).to_s).to eq("99,999,999,999,990 ")
    end
    it 'should allow scalar/quantity' do
      expect((2/Period.milliseconds(100)).to_s).to eq('Frequency: 20 Hz')
      expect((2.5/Period.milliseconds(100)).to_s).to eq('Frequency: 25 Hz')
      expect((BigDecimal(2.5,2)/Period.milliseconds(100)).to_s).to eq('Frequency: 25 Hz')
      expect((200000000**2/Period.milliseconds(100)).to_s).to eq('Frequency: 400,000,000,000,000,000 Hz')
    end
    it 'should allow scalar*quantity' do
      expect((2*Period.milliseconds(100)).to_s).to eq('Period: 200 ms')
      expect((2.5*Period.milliseconds(100)).to_s).to eq('Period: 250 ms')
      expect((BigDecimal(2.5,2)*Period.milliseconds(100)).to_s).to eq('Period: 250 ms')
      expect((200000000**2*Period.milliseconds(100)).to_s).to eq('Period: 4,000,000,000,000,000,000 ms')
    end
  end
end
