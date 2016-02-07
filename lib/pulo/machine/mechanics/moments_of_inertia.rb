module Pulo
  class MomentOfInertia
    def self.point_mass(mass, distance)
      mass*distance**2
    end

    #rod around its mid point
    def self.rod(mass, length)
      (mass*distance**2)/12.0
    end

    #rod around its mid point
    def self.rod_end(mass, length)
      (mass*length**2)/3.0
    end

    #hoop
    def self.hoop(mass, radius)
      (mass*radius**2)/2.0
    end

    #disc
    def self.disc(mass, radius)
      (mass*radius**2)/4.0
    end

    #cylindrical shell on its axis
    def self.cylindrical_shell(mass, radius)
      (mass*radius**2)
    end

    def self.cylinder(mass, radius, height)
      (3*radius**2+height**2)*mass/12.0
    end

    def self.tube(mass, inner_radius,outer_radius)
      (inner_radius**2+outer_radius**2)*mass/2.0
    end

    def self.spherical_shell(mass, radius)
      (2*mass*radius**2)/3.0
    end

    def self.sphere(mass, radius)
      (2*mass*radius**2)/5.0
    end

    def self.thick_spherical_shell(mass, inner_radius,outer_radius)
      ((outer_radius**5-inner_radius**5)/(outer_radius**3-inner_radius**3))*(2*mass/5)
    end

    def self.cone(mass, radius, height)
      (radius**2+4*height**2)*(3*mass/20)
    end

    #cuboid or plate of arbitrary depth (in direction of axis of rotation)
    def self.cuboid(mass, width, height)
      (height**2+width**2)*(mass/12)
    end



  end
end