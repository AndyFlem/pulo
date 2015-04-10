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
      expect(Math.cos(@angle).to_s).to eq("Dimensionless: 0 ")
      expect(Math.sin(@angle).to_s).to eq("Dimensionless: 1 ")
      expect(Math.tan(@angle2).to_s).to eq("Dimensionless: 1 ")
    end
    it 'should allow reverse trigonometric functions on dimensionless' do
      expect(Math.acos(@dimless2).to_s).to eq("Angle: 1.05 rad")
      expect(Math.asin(@dimless2).to_s).to eq("Angle: 0.52 rad")
      expect(Math.atan(@dimless2).to_s).to eq("Angle: 0.55 rad")
    end
  end
end
