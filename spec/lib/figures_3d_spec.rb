# encoding: utf-8

require 'spec_helper'

module Pulo
  describe Sphere do
    it 'should create a sphere from a radius' do
      expect(Sphere.new(radius: Length.meters(1)).volume.to_s).to eq("Volume: 4.19 m\u00B3")
    end
    it 'should create a sphere from a diameter' do
      expect(Sphere.new(diameter: Length.meters(2)).surfacearea.to_s).to eq("Area: 12.57 m\u00B2")
    end
    it 'should create a sphere from a volume' do
      expect(Sphere.new(volume: Volume.cubic_meters(1)).radius.to_s).to eq("Length: 0.62 m")
    end
  end

  describe Cylinder do
    it 'should create a cylinder from a radius and length' do
      expect(Cylinder.new(radius: Length.meters(2), length: Length.meters(1)).volume.to_s).to eq("Volume: 12.57 m\u00B3")
    end
    it 'should create a cylinder from a radius and volume' do
      expect(Cylinder.new(diameter: Length.meters(2), volume: Volume.litres(5000)).length.to_s).to eq("Length: 1.59 m")
    end
  end

end