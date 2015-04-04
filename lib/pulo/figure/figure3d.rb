
module Pulo

  module Figure3D
  attr_reader :volume, :surfacearea

  def + (other)
    raise "Cant add a #{other.class} to a Figure3D" unless other.is_a?(Figure3D)
    self.class.new(volume: self.volume+other.volume)
  end
  def - (other)
    raise "Cant minus a #{other.class} from a Figure3D" unless other.is_a?(Figure3D)
    self.class.new(volume: self.volume-other.volume)
  end
  def * (other)
    if other.is_a?(Numeric)
      self.class.new(volume: self.volume*other)
    else
      raise "Dont know how to multiply a #{self.class} by a #{other.class}"
    end
  end
  def / (other)
    if other.is_a?(Numeric)
      self.class.new(volume: self.volume/other)
    elsif other.is_a?(Length)
      self.volume/other
    else
      raise "Dont know how to divide a #{self.class} by a #{other.class}"
    end
  end
end

  class Cylinder
    include Figure3D

    attr_reader :face, :length, :area, :radius
    def initialize (face: nil, length: nil, volume: nil, radius: nil, diameter: nil)
      quantity_check [face,Circle] ,[length,Length] , [volume,Volume], [radius, Length], [diameter, Length]
      if face and length
        @face=face
        @length=length
        @volume=@face.area*@length
      else
        if volume and length
          @length=length
          @volume=volume
          @face=Circle.new(area: @volume/@length)
        else
          if (radius or diameter) and volume
            @face=Circle.new(radius: radius, diameter: diameter)
            @volume=volume
            @length=volume/@face.area
          else
            @face=Circle.new(radius: radius, diameter: diameter)
            @length=length
            @volume=@face.area*@length
          end
        end
      end

      @surfacearea=@face.area*2+@face.perimeter*@length
      @area=@face.area
      @radius=@face.radius
    end
  end

  class TrapezoidalPrism
    include Figure3D
    attr_reader :face, :length
    attr_reader :base_area,:side_area,:top_area
    def initialize(face: nil, length: nil, angle: nil,height: nil,base: nil, area: nil)
      if face
        raise "Please provide a trapezoid as the face." unless face.is_a?(Trapezoid)
        @face=face
      else
        @face=Trapezoid.new(angle: angle, height: height, base: base, area: area)
        @length=Length.new(length)
        @volume=@face.area*@length
        @base_area=@face.base*@length
        @side_area=@face.side*@length
        @top_area=@face.top*@length
        @surfacearea=@face.area*2+@base_area+@top_area+@side_area*2
      end
    end
  end

  class Cube
    include Figure3D
    attr_reader :width, :face

    def initialize(width: nil, face: nil, volume: nil)
      raise "Cube needs volume or face or width." unless (width || volume || face)

      if volume
        @volume=Volume.new(volume); @width=volume.root(3); @face=Square.new(width: @width)
      elsif face
        @face=face; @width=@face.width; @volume=@face*@width
      elsif width
        @width=Length.new(width); @face=Square.new(width: @width); @volume=@face*@width
      end
      @surfacearea=@face.area*6
    end
  end

  class Cuboid
    include Figure3D
    attr_reader :width, :length, :height, :faces
    def initialize(width: nil, height: nil, length: nil, volume: nil, face: nil)
      raise "Cuboid needs width, length and height or volume and face or length and face." unless ((width && length && height) || (volume && face) || (length && face))

      @faces=[]
      if width and length and height
        @width=width; @length=length; @height=height
        @faces[0]=Rectangle.new(width: width, height: height)
        @faces[1]=Rectangle.new(width: width, height: length)
        @faces[2]=Rectangle.new(width: length, height: height)
        @volume=@faces[0]*@length
      end
      if volume and face
        @volume=volume
        @faces[0]=face
        @width=@faces[0].width
        @length=@faces[0].height
        @height=@volume/@faces[0].area
        @faces[1]=Rectangle.new(width: @width, height: @height)
        @faces[2]=Rectangle.new(width: @length, height: @height)
      end
      if face and length
        @faces[0]=face
        @length=length
        @volume=face.area * length
        @width=@faces[0].width
        @height=@faces[0].height
        @faces[1]=Rectangle.new(width: @width, height: @length)
        @faces[2]=Rectangle.new(width: @length, height: @height)
      end
      @surfacearea=(@faces[0].area+@faces[1].area+@faces[2].area)*2
    end
  end

  class Sphere
    include Figure3D
    attr_reader :radius,:diameter
    def initialize(radius: nil, diameter: nil, volume: nil)
      if volume
        @volume=volume
        @radius=(@volume.value*3/(4*Math::PI)).root(3)
        @diameter=@radius*2
      else
        if diameter
          @diameter=diameter
          @radius=@diameter/2
        else
          @radius=radius
          @diameter=@radius*2
        end
        @volume=(@radius.value**3)*(4.0/3.0)*Math::PI
      end
      @surfacearea=@radius.value**2*(4*Math::PI)
    end
  end

end