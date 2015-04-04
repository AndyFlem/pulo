
module Pulo

  module Figure2D

    attr_reader :area,:perimeter
    def + (other)
      raise "Cant add a #{other.class} to a #{self.class} " unless other.respond_to?(:area)
      self.class.new(area: self.area+other.area)
    end
    def - (other)
      raise "Cant minus a #{other.class} from a #{self.class}" unless other.respond_to?(:area)
      raise "Cant produce a negative area for Figure2D." if ((self.area-other.area).value)<0
      self.class.new(area: self.area-other.area)
    end
    def * (other)
      if other.is_a?(Numeric)
        self.class.new(area: self.area*other)
      elsif other.is_a?(Length)
        raise "No extrusion figure known for #{self.class}" unless self.respond_to?(:extrusion_figure)
        self.extrusion_figure.new(face: self, length: other)
      else
        raise "Dont know how to multiply a #{self.class} by a #{other.class}"
      end
    end
    def / (other)
      if other.is_a?(Numeric)
        self.class.new(area: self.area/other)
      else
        raise "Dont know how to divide a #{self.class} by a #{other.class}"
      end
    end
  end

  class Circle
    include Figure2D
    attr_reader :radius,:diameter
    def extrusion_figure
      Cylinder
    end
    def initialize(radius: nil, diameter: nil, area: nil)
      raise "Circle needs area or diameter or radius." unless (area || diameter || radius)

      quantity_check [radius,Length] ,[diameter,Length] , [area,Area]
      if area
        @area=area;
        @radius=(@area/Math::PI).rt(2);
        @diameter=@radius*2
      else
        if diameter
          @diameter=diameter;
          @radius=@diameter/2
        else
          @radius=radius;
          @diameter=@radius*2
        end
        @area=(@radius**2)*Math::PI
      end
      @perimeter=@radius*2*Math::PI
    end
  end

  class Square
    include Figure2D

    attr_reader :length
    def initialize(length: nil, area: nil)
      raise "Square needs area or length." unless (area || length)

      quantity_check [area,Area] ,[length,Length]
      if area
        @area=area; @length=@area.rt(2)
      else
        @length=length; @area=@length**2
      end
      @perimeter=@length*4
    end
  end

  class Rectangle
    include Figure2D

    attr_reader :width, :height

    def extrusion_figure
      Cuboid
    end
    def initialize(area: nil, width: nil, height: nil)
      quantity_check [area,Area] ,[width,Length] , [height,Length]
      raise "Rectangle needs width and height or area and width or height." unless (width && height) || (area && (width || height))
      if area
        @area=area
        if width
          @width=width; @height=@area/@width
        elsif height
          @height=height; @width=@area/@height
        else
          @width=@area.rt(2); @height=@area.rt(2)
        end
      else
        @width=width; @height=height
        @area=@width*@height
      end
      @perimeter=@width*2+@height*2
    end
  end

  class Triangle
    include Figure2D

    attr_reader :angles,:lengths
    def initialize(angles: [], lengths: [], area: nil)
      raise "Need more arguments for triangle" unless (
            ((not area) && angles.count+lengths.count>=3 && lengths.count>0) ||
            (area && (angles.count>=2 || lengths.count>=2 || (lengths.count==1 && angles.count>0)))
      )
      while lengths.count<3; lengths<<nil; end
      while angles.count<3; angles<<nil; end

      #lengths=lengths.collect do |l|
      #  if l.is_a?(Length)
      #    l.value
      #  else
      #    l==nil ? l : l.to_f
      #  end
      #end
      #angles=angles.collect { |a|
      #  a.is_a?(Angle) ? a.radians.value : a==nil ? a : a.to_f
      #}

      lengthsCount=lengths.compact.count
      anglesCount=angles.compact.count
      if area
        #area=area.value if area.is_a?(Area)
        if anglesCount==2
          while angles[0]==nil
            angles=angles.unshift(angles.last).take(3)
            lengths=lengths.unshift(lengths.last).take(3)
          end
          angles[2]=Angle.pi-angles[0]-angles[1]
          k=((area*2)/(Math.sin(angles[0])*Math.sin(angles[1])*Math.sin(angles[2]))).rt(2)
          lengths[0]=k*Math.sin(angles[0])
          lengths[1]=k*Math.sin(angles[1])
          lengths[2]=k*Math.sin(angles[2])
        else
          if lengthsCount==2
            while lengths[0]==nil or lengths[1]==nil
              lengths=lengths.unshift(lengths.last).take(3)
              angles=angles.unshift(angles.last).take(3)
            end
            angles[0]=AngleFromArea(area,lengths[0],lengths[1])
            lengths[2]=LengthFromCosine(lengths[0],lengths[1],angles[0])
            angles[1]=AngleFromSine(lengths[0],lengths[2],angles[0])
            angles[2]=Angle.pi-angles[0]-angles[1]
          else
            while lengths[0]==nil
              lengths=lengths.unshift(lengths.last).take(3)
              angles=angles.unshift(angles.last).take(3)
            end
            if angles[0]!=nil
              lengths[1]=LengthFromArea(area,lengths[0],angles[0])
              lengths[2]=LengthFromCosine(lengths[0],lengths[1],angles[0])
              angles[1]=AngleFromSine(lengths[0],lengths[2],angles[0])
              angles[2]=Angles.pi-angles[0]-angles[1]
            elsif angles[1]!=nil
              #assume isocelese
              angles[0]=angles[2]=(Angles.pi-angles[1])/2
              lengths[1]=LengthFromArea(area,lengths[0],angles[0])
              lengths[2]=LengthFromCosine(lengths[0],lengths[1],angles[0])
            else
              lengths[2]=LengthFromArea(area,lengths[0],angles[2])
              lengths[1]=LengthFromCosine(lengths[0],lengths[2],angles[2])
              angles[0]=AngleFromSine(lengths[2],lengths[1],angles[2])
              angles[1]=Angles.pi-angles[0]-angles[2]
            end
          end
        end

        @area=area
      else
        if lengthsCount==3
          angles[0]=AngleFromCosine(lengths[2],lengths[0],lengths[1])
          angles[1]=AngleFromSine(lengths[0],lengths[2],angles[0])
          angles[2]=Angle.pi-angles[0]-angles[1]
        elsif lengthsCount==2
          while lengths[0]==nil or lengths[1]==nil
            lengths=lengths.unshift(lengths.last).take(3)
            angles=angles.unshift(angles.last).take(3)
          end
          if angles[0]!=nil
            lengths[2]=LengthFromCosine(lengths[0],lengths[1],angles[0])
            angles[1]=AngleFromSine(lengths[0],lengths[2],angles[0])
            angles[2]=Angle.pi-angles[0]-angles[1]
          elsif angles[1]!=nil
            angles[2]=AngleFromSine(lengths[1],lengths[0],angles[1])
            angles[0]=Angle.pi-angles[1]-angles[2]
            lengths[2]=LengthFromSine(lengths[0],angles[0],angles[1])
          else
            angles[1]=AngleFromSine(lengths[0],lengths[1],angles[2])
            angles[0]=Angle.pi-angles[1]-angles[2]
            lengths[2]=LengthFromSine(lengths[0],angles[0],angles[1])
          end
        else
          while angles[0]==nil or angles[1]==nil
            lengths=lengths.unshift(lengths.last).take(3)
            angles=angles.unshift(angles.last).take(3)
          end
          angles[2]=Angle.pi-angles[0]-angles[1]
          if lengths[0]!=nil
            lengths[1]=LengthFromSine(lengths[0],angles[2],angles[1])
            lengths[2]=LengthFromSine(lengths[0],angles[0],angles[1])
          elsif lengths[1]!=nil
            lengths[0]=LengthFromSine(lengths[1],angles[1],angles[2])
            lengths[2]=LengthFromSine(lengths[0],angles[0],angles[1])
          elsif lengths[2]!=nil
            lengths[0]=LengthFromSine(lengths[2],angles[1],angles[0])
            lengths[1]=LengthFromSine(lengths[0],angles[2],angles[1])
          end
        end
        @area=0.5*lengths[2]*lengths[0]*Math.sin(angles[2])
      end
      @angles=angles
      @lengths=lengths
      @perimeter=@lengths[0]+@lengths[1]+@lengths[2]
    end
    def LengthFromCosine(b,c,angA); Math.sqrt(b**2+c**2-(2*b*c*Math.cos(angA))); end
    def AngleFromCosine(a,b,c); Math.acos((b**2+c**2-a**2)/(2*b*c)); end
    def LengthFromSine(b,angA,angB); b/Math.sin(angB)*Math.sin(angA); end
    def AngleFromSine(a,b,angB); Math.asin(a*Math.sin(angB)/b); end
    def LengthFromArea(area,b,angC); (2*area)/(b*Math.sin(angC)); end
    def AngleFromArea(area,a,b); Math.asin(2*area/(a*b)); end
  end

  class Trapezoid #isoscelese only
    include Figure2D


    attr_reader :base,:top,:height,:angle,:side_triangle,:side
    def initialize(angle: nil,height: nil,base: nil, area: nil)
      if angle and height and (base or width)
        @angle=Angle.new(angle); @height=Length.new(height)
        @side_triangle=Triangle.new(angles: [@angle,nil,Math::PI/2], lengths: [@height,nil,nil])
        @side=@side_triangle.lengths[2]
        if base
          @base=Length.new(base); @top=@base+@side_triangle.lengths[0]*2
        else
          @top=Length.new(top); @base=@top-@side_triangle.lengths[0]*2
        end
        @area=(@top+@base)*@height*0.5; @perimeter=@base+@top+(@side)
      elsif area and angle and base
        @angle=Angle.new(angle); @area=Area.new(area); @base=Length.new(base)
        @height=Length.new((-@base.value+Math.sqrt((@base.value**2)+(4*Math.tan(@angle.value)*@area.value)))/(2*Math.tan(@angle.value)))
        @side_triangle=Triangle.new(angles: [@angle,nil,Math::PI/2], lengths: [@height,nil,nil])
        @side=@side_triangle.lengths[2]
        @top=@base+@side_triangle.lengths[0]*2
        @perimeter=@base+@top+(@side)
      end
    end
  end
end