# encoding: utf-8

require_relative '../../spec/spec_helper'

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

  describe Cube do
    it 'should create a cube from a volume' do
      expect(Cube.new(volume: Volume.cubic_meters(27)).face.width.to_s).to eq("Length: 3 m")
    end
    it 'should create a cube from a length' do
      expect(Cube.new(length: Length.meters(3)).volume.to_s).to eq("Volume: 27 m\u00B3")
    end
    it 'should create a cube from a square face' do
      expect(Cube.new(face: Square.new(width: Length.meters(3))).volume.to_s).to eq("Volume: 27 m\u00B3")
    end
  end

  describe Cuboid do
    it 'should create a cuboid from a face and length' do
      expect(Cuboid.new(length: Length.meters(1), face: Rectangle.new(width: Length.meters(1), height: Length.meters(2))).volume.to_s).to eq("Volume: 2 m\u00B3")
    end
    it 'should create a cuboid from a face and volume' do
      expect(Cuboid.new(volume: Volume.cubic_meters(6), face: Rectangle.new(width: Length.meters(1), height: Length.meters(2))).length.to_s).to eq("Length: 3 m")
    end
    it 'should create a cuboid from a width, height and length' do
      expect(Cuboid.new(width: Length.meters(6), height: Length.meters(2),length: Length.meters(1)).volume.to_s).to eq("Volume: 12 m\u00B3")
    end
  end

  describe Cylinder do
    it 'should create a cylinder from a circular face and length' do
      expect(Cylinder.new(length: Length.meters(1.59), face: Circle.new(diameter: Length.meters(2))).volume.litres.to_s).to eq("Volume: 4,995.13 lt")
    end
    it 'should create a cylinder from a radius and length' do
      expect(Cylinder.new(radius: Length.meters(2), length: Length.meters(1)).volume.to_s).to eq("Volume: 12.57 m\u00B3")
    end
    it 'should create a cylinder from a diameter and volume' do
      expect(Cylinder.new(diameter: Length.meters(2), volume: Volume.litres(5000)).length.to_s).to eq("Length: 1.59 m")
    end
    it 'should create a cylinder from a length and volume' do
      expect(Cylinder.new(length: Length.meters(2), volume: Volume.litres(5000)).face.radius.to_s).to eq("Length: 0.89 m")
    end
  end

  describe Prism do
    it 'should create a prism from a face and length' do
      expect(Prism.new(length: Length.meters(2), face: Triangle.new(lengths: [Length.meters(1),Length.meters(1),Length.meters(1)])).volume.litres.to_s).to eq("Volume: 866.03 lt")
    end
  end

  describe TrapezoidalPrism do
    it 'should create a trapezoidal prism from a face and length' do
      expect(
          TrapezoidalPrism.new(
              length: Length.meters(2),
              face: Trapezoid.new(
                  angle: Angle.degrees(45),
                  height: Length.meters(10),
                  base:Length.meters(30))).volume.litres.to_s).to eq("Volume: 400,000 lt")
    end
  end

end