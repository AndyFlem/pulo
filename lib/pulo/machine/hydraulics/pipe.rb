module Pulo

  class PipeTypes
  attr_reader :pipe_types
  def initialize
    pipe_groups={
        uPvc: {Chw: 150, density: Density.kilograms_per_cubic_meter(1800), unit_length: Length.meters(6)}
    }
    @pipe_types={
        class6_160: {group: :uPvc, od: Length.millimeters(160.0), id: Length.millimeters(153.6), unit_cost: Value.dollars(50)},
        class6_200: {group: :uPvc, od: Length.millimeters(200.0), id: Length.millimeters(192.2), unit_cost: Value.dollars(78)},
        class6_250: {group: :uPvc, od: Length.millimeters(250.0), id: Length.millimeters(242.0), unit_cost: Value.dollars(105)},
        class6_315: {group: :uPvc, od: Length.millimeters(315.0), id: Length.millimeters(302.6), unit_cost: Value.dollars(232)},
        class6_355: {group: :uPvc, od: Length.millimeters(355.0), id: Length.millimeters(341.0), unit_cost: Value.dollars(326)},
        class6_400: {group: :uPvc, od: Length.millimeters(400.0), id: Length.millimeters(384.4), unit_cost: Value.dollars(440)},
        class6_450: {group: :uPvc, od: Length.millimeters(450.0), id: Length.millimeters(428.8), unit_cost: Value.dollars(610)},
        class6_500: {group: :uPvc, od: Length.millimeters(500.0), id: Length.millimeters(476.4), unit_cost: Value.dollars(750)}
    }
    @pipe_types.values.each do |pt|
      pt.merge!(pipe_groups[pt[:group]])
    end
  end
end


  class Pipeline

  attr_reader :inside_cylinder,:outside_cylinder,:length
  attr_reader :wall_thickness, :wall_area, :wall_volume,  :mass
  attr_reader :pipe_type
  attr_reader :wall_density
  attr_reader :inlet_pressure,:outlet_pressure, :flow
  attr_reader :friction_gradient, :static_head, :friction_head, :total_head, :flow_velocity, :hydraulic_power
  attr_reader :cost

  def initialize(args)

    @pipe_type_ref=args[:pipe]
    @pipe_type=PipeTypes.new().pipe_types[@pipe_type_ref]

    @length=args[:length]
    @cost=@length*@pipe_type[:unit_cost]/@pipe_type[:unit_length]
    @inside_cylinder=Cylinder.new(diameter: @pipe_type[:id], length: @length)
    @outside_cylinder=Cylinder.new(diameter: @pipe_type[:od], length: @length)
    @wall_thickness=@outside_cylinder.radius-@inside_cylinder.radius
    @wall_area=@outside_cylinder.area-@inside_cylinder.area
    @wall_volume=@outside_cylinder.volume-@inside_cylinder.volume
    @mass=@wall_volume*@pipe_type[:density]

    args[:static_head] ? @static_head=args[:static_head] : @static_head=Length.meters(0)
    args[:inlet_pressure] ? @inlet_pressure=args[:inlet_pressure] : @inlet_pressure=Pressure.pascals(0)
    args[:outlet_pressure] ? @outlet_pressure=args[:outlet_pressure] : @outlet_pressure=Pressure.pascals(0)
    @pressure_head=(@outlet_pressure-@inlet_pressure)/(Water.standard_density*Acceleration.standard_gravity)
  end

  def flow=(val)
    @flow=val
    @flow_velocity=@flow/inside_cylinder.area
    head_for_flow()
    @hydraulic_power=((@flow*Water.standard_density)*Acceleration.standard_gravity)*@total_head
  end

  def head_for_flow()
    k=(@pipe_type[:Chw]**1.85)*@inside_cylinder.face.diameter.meters.value**4.87
    @friction_gradient=Dimensionless.n(10.67*@flow.cubic_meter_per_second.value**1.85/k)
    @friction_head=@length * @friction_gradient
    @total_head=@friction_head+@static_head+@pressure_head
  end
end

end