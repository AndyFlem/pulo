
module Pulo

  module Figure3D
    attr_reader :volume, :surfacearea
  end

  class Sphere
    include Figure3D
    attr_reader :radius,:diameter
    def initialize(radius: nil, diameter: nil, volume: nil)
      quantity_check [radius,Length] ,[diameter,Length], [volume, Volume]
      raise "Need more arguments for Sphere" unless volume or diameter or radius
      if volume
        @volume=volume
        @radius=(@volume*3/(Angle.pi*4)).rt(3)
        @diameter=@radius*2
      else
        if diameter
          @diameter=diameter
          @radius=@diameter/2
        else
          @radius=radius
          @diameter=@radius*2
        end
        @volume=(@radius**3)*(4.0/3.0)*Angle.pi
      end
      @surfacearea=@radius**2*(4*Angle.pi)
    end
  end

  class Cube
    include Figure3D
    attr_reader :length, :face

    def initialize(length: nil, face: nil, volume: nil)
      quantity_check [length,Length] ,[face,Square], [volume, Volume]
      raise "Cube needs volume or face or length." unless (length || volume || face)

      if volume
        @volume=volume;
        @length=volume.rt(3);
        @face=Square.new(width: @length)
      elsif face
        @face=face;
        @length=@face.width;
        @volume=@face.area*@length
      elsif length
        @length=length;
        @face=Square.new(width: @length);
        @volume=@face.area*@length
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
        @volume=@faces[0].area*@length
      end
      if volume and face
        @volume=volume
        @faces[0]=face
        @width=@faces[0].width
        @height=@faces[0].height
        @length=@volume/@faces[0].area
        @faces[1]=Rectangle.new(width: @width, height: @length)
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

  class Cylinder
    include Figure3D

    attr_reader :face, :length
    def initialize (face: nil, length: nil, volume: nil, radius: nil, diameter: nil)
      quantity_check [face,Circle] ,[length,Length] , [volume,Volume], [radius, Length], [diameter, Length]
      raise "Cylinder needs length and face or volume and length or volume and radius or diameter." unless
          (face and length) or (volume and length) or (volume and (radius or diameter)) or (length and (radius or diameter))

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

  class Prism
    include Figure3D
    attr_reader :face, :length
    attr_reader :side_areas
    def initialize(face: nil, length: nil)
      quantity_check [face,Triangle] ,[length,Length]
      raise "Prism needs a face and length." unless face and length
      @face=face
      @length=length
      @volume=@face.area*@length
      @side_areas=[]
      @side_areas[0]=@face.lengths[0]*@length
      @side_areas[1]=@face.lengths[1]*@length
      @side_areas[2]=@face.lengths[2]*@length
      @surfacearea=@face.area*2+@side_areas[0]+@side_areas[1]+@side_areas[2]
    end
  end

  class TrapezoidalPrism
    include Figure3D
    attr_reader :face, :length
    attr_reader :base_area,:side_area,:top_area
    def initialize(face: nil, length: nil)
      quantity_check [face,Trapezoid] ,[length,Length]
      raise "TrapezoidalPrism needs a face and length." unless face and length
      @face=face
      @length=length
      @volume=@face.area*@length
      @base_area=@face.base*@length
      @side_area=@face.side*@length
      @top_area=@face.top*@length
      @surfacearea=@face.area*2+@base_area+@top_area+@side_area*2
    end
  end

end