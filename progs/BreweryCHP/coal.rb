require_relative '../../lib/pulo'

$precision=4
$significant=true
$no_quantity_names=true


class MaambaCoal
  attr_reader :hhv, :lhv, :gate_price,:transport_rate,:transport_cost,:unit_cost,:energy_cost

  def initialize(transport_distance: nil)
    @hhv=SpecificEnergy.kilocalories_per_kilogram((6294+6482)/2)
    @lhv=@hhv*Dimensionless.percent(95)
    @gate_price=MassValue.dollars_per_tonne(85) #(2012) specific cost
    @transport_rate=SpecificTransportCost.dollars_per_tonne_kilometer(0.15)
    @transport_cost=@transport_rate*transport_distance
    @unit_cost=@transport_cost+@gate_price
    @energy_cost=@unit_cost/@lhv
  end

  def to_s
    r="Maamba coal LHV: #{lhv.megajoules_per_tonne} #{lhv.btu_per_pound}\n"
    r+="Maamba coal gate cost: #{gate_price.dollars_per_tonne}\n"
    r+="Maamba coal transport: #{transport_cost.dollars_per_tonne}\n"
    r+="Maamba coal delivered cost: #{unit_cost.dollars_per_tonne}\n"
    r
  end
end
