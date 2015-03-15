# encoding: utf-8

require 'spec_helper'

describe 'Creating cylinders' do
  it 'should create a cylinder from a radius and length' do
    expect(Cylinder.new(radius: Length.meters(2), length: Length.meters(1)).volume.to_s).to eq("Volume: 12.57 m\u00B3")
  end
  it 'should create a cylinder from a radius and volume' do
    expect(Cylinder.new(diameter: Length.meters(2), volume: Volume.litres(5000)).length.to_s).to eq("Length: 1.59 m")
  end
end
