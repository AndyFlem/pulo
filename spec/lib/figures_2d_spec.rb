# encoding: utf-8

require 'spec_helper'

module Pulo

  describe Figure2D do

    it 'should raise exception trying to multiply by wrong type of object' do
      expect{Square.new(area: Area.square_meters(2))*Time.new()}.to raise_error(RuntimeError)
    end

  end

  describe Circle do

    it 'should create a circle from a radius' do
      expect(Circle.new(radius: Length.inches(2)).area.to_s).to eq("Area: 81.07 cm²")
    end
    it 'should create a circle from a diameter' do
      expect(Circle.new(diameter: Length.inches(4)).area.to_s).to eq("Area: 81.07 cm²")
    end
    it 'should create a circle from an area' do
      expect(Circle.new(area: Area.square_meters(4*Math::PI)).radius.to_s).to eq("Length: 2 m")
    end
    it 'should raise exception on incorrect argument types' do
      expect{Circle.new(radius: Area.square_inches(2))}.to raise_error(RuntimeError)
    end
    it 'should give a cylinder for multiplication by length' do
      expect((Circle.new(radius: Length.meters(1)) * Length.meters(1)).class).to eq(Cylinder)
    end
  end

  describe Square do
    it 'should create a square form a length' do
      expect(Square.new(length: Length.inches(3)).area.to_s).to eq("Area: 58.06 cm\u00B2")
    end
    it 'should create a square form an area' do
      expect(Square.new(area: Area.square_meters(1)).length.to_s).to eq("Length: 1 m")
    end
    it 'should raise exception on incorrect argument types' do
      expect{Square.new(length: Area.square_meters(2))}.to raise_error(RuntimeError)
    end

  end

  describe Rectangle do
    it 'should create a rectangle from width and height' do
      expect(Rectangle.new(width: Length.inches(3), height: Length.meters(5)).area.to_s).to eq("Area: 0.38 m²")
    end
    it 'should create a rectangle from an area and width' do
      expect(Rectangle.new(area: Area.square_meters(4), width: Length.meters(2)).width.to_s).to eq("Length: 2 m")
    end
    it 'should raise exception on incorrect argument types' do
      expect{Rectangle.new(height: Area.square_inches(2),width: Length.meters(2))}.to raise_error(RuntimeError)
    end
    it 'should raise exception on incorrect arguments' do
      expect{Rectangle.new(width: Length.meters(2))}.to raise_error(RuntimeError)
    end
    it 'should give a cuboid for multiplication by length' do
      expect((Rectangle.new(width: Length.meters(1),height: Length.meters(1)) * Length.meters(1)).class).to eq(Cuboid)
    end

  end

  describe Triangle do
    it 'should create a triangle from three lengths' do
      expect(Triangle.new(lengths: [Length.meters(3),Length.meters(4),Length.meters(5)]).angles[1].degrees.to_s).to eq("Angle: 36.87 deg")
    end
    it 'should create a triangle from two lengths and an angle' do
      expect(Triangle.new(lengths: [Length.meters(3),Length.meters(4)], angles:[Angle.degrees(90)]).angles[1].degrees.to_s).to eq("Angle: 36.87 deg")
    end
    it 'should create a triangle from two lengths and an angle' do
      expect(Triangle.new(lengths: [Length.meters(3),nil,Length.meters(5)], angles:[Angle.degrees(90)]).angles[2].degrees.to_s).to eq("Angle: 36.87 deg")
    end
    it 'should create a triangle from two lengths and an angle' do
      expect(Triangle.new(lengths: [nil,Length.meters(4),Length.meters(5)], angles:[Angle.degrees(90)]).angles[0].degrees.to_s).to eq("Angle: 36.87 deg")
    end
    it 'should create a triangle from a length and two angles' do
      expect(Triangle.new(lengths: [Length.meters(3)], angles:[Angle.degrees(90),Angle.degrees(36.87)]).angles[2].degrees.to_s).to eq("Angle: 53.13 deg")
    end
    it 'should create a triangle from an area and two angles' do
      expect(Triangle.new(area: Area.square_inches(6), angles:[Angle.degrees(90),Angle.degrees(36.87)]).lengths[2].inches.to_s).to eq("Length: 4 in")
    end
    it 'should create a triangle from an area and two lengths' do
      expect(Triangle.new(area: Area.square_inches(6), lengths: [Length.inches(3),Length.inches(4)]).lengths[2].inches.to_s).to eq("Length: 5 in")
    end
    it 'should create a triangle from an area, length and angle' do
      expect(Triangle.new(area: Area.square_inches(6), angles:[Angle.degrees(90)], lengths: [Length.inches(3)]).lengths[2].inches.to_s).to eq("Length: 5 in")
    end
    it 'should create a triangle from an area, length and angle' do
      expect(Triangle.new(area: Area.square_inches(6), angles:[nil,Angle.degrees(36.87)], lengths: [Length.inches(3)]).lengths[2].inches.to_s).to eq("Length: 4.33 in")
    end
    it 'should create a triangle from an area, length and angle' do
      expect(Triangle.new(area: Area.square_inches(6), angles:[nil,nil,Angle.degrees(53.13)], lengths: [Length.inches(3)]).lengths[2].inches.to_s).to eq("Length: 5 in")
    end

    it 'should raise exception on incorrect arguments' do
      expect{Triangle.new(angles:[Angle.degrees(90),Angle.degrees(36.87),Angle.degrees(53.13)])}.to raise_error(RuntimeError)
    end
  end

  describe Trapezoid do
    it 'should create a trapezoid form angle height and base' do
      expect(Trapezoid.new(angle: Angle.degrees(45), height: Length.meters(10), base:Length.meters(30) ).area.to_s).to eq("Area: 200 m\u00B2")
    end
    it 'should create a trapezoid form angle height and top' do
      expect(Trapezoid.new(angle: Angle.degrees(45), height: Length.meters(10), top:Length.meters(10) ).perimeter.to_s).to eq("Length: 68.28 m")
    end
    it 'should create a trapezoid form base height and top' do
      expect(Trapezoid.new(base: Length.meters(30), height: Length.meters(10), top:Length.meters(10) ).perimeter.to_s).to eq("Length: 68.28 m")
    end
    it 'should create a trapezoid form area, base and top' do
      expect(Trapezoid.new(area: Area.square_meters(200), base: Length.meters(30), top:Length.meters(10) ).perimeter.to_s).to eq("Length: 68.28 m")
    end

    #it 'should create a trapezoid from area angle and base' do
    #  expect(Trapezoid.new(area: Area.square_meters(200), base: Length.meters(30), angle: Angle.degrees(45) ).height.to_s).to eq("Length: 10 m")
    #  expect(Trapezoid.new(area: Area.square_meters(200), base: Length.meters(30), angle: Angle.degrees(45) ).perimeter.to_s).to eq("Length: 68.28 m")
    #end

  end

end