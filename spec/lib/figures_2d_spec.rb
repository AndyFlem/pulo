# encoding: utf-8

require 'spec_helper'

describe 'Creating circles' do
  it 'should create a circle from a radius' do
    expect(Circle.new(radius: Length.inches(2)).area.to_s).to eq("Area: 81.07 cm²")
  end
  it 'should create a circle from a diameter' do
    expect(Circle.new(diameter: Length.inches(4)).area.to_s).to eq("Area: 81.07 cm²")
  end
  it 'should create a circle from an area' do
    expect(Circle.new(area: Area.square_meters(4*Math::PI)).radius.to_s).to eq("Length: 2 m")
  end
end

describe 'Creating rectangles' do
  it 'should create a rectangle from width and height' do
    expect(Rectangle.new(width: Length.inches(3), height: Length.meters(5)).area.to_s).to eq("Area: 0.38 m²")
  end
  it 'should create a rectangle from an area' do
    expect(Rectangle.new(area: Area.square_meters(4)).width.to_s).to eq("Length: 2 m")
  end
end


describe 'Some errors' do
  it 'should check argument types' do
    expect{Circle.new(radius: Area.square_inches(2))}.to raise_error(QuantitiesException)
  end
end
