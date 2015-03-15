

class CostOfElectricity

  attr_reader :energy_demand,:resultant_energy_cost,:energy_cost,:demand_cost,:fixed_charge,:excise_cost,:total_cost, :resulting_energy_cost,:peak_demand,:peak_kVA,:tarrif

  def initialize(energy_demand: nil, receive_offpeak: false, peak_demand_over_average: Dimensionless.percent(180),power_factor: Dimensionless.n(0.75))
    @energy_demand=energy_demand
    kperd=6.3
    excise=Dimensionless.percent(3)

    off_peak_proportion=Dimensionless.n(7.0/24.0)

    off_peak_proportion=0 unless receive_offpeak

    #16-300 kVA
    md1={:name=>"MD1",:md_peak=>ValueFlow.dollars_per_month(13.97/kperd),
         :md_off=>ValueFlow.dollars_per_month(6.99/kperd),
         :energy_peak=>EnergyValue.dollars_per_kilowatt_hour(0.20/kperd),
         :energy_offpeak=>EnergyValue.dollars_per_kilowatt_hour(0.16/kperd),
         :fixed=>ValueFlow.dollars_per_month(136.81/kperd)}

    #3001-2000
    md2={:name=>"MD2",:md_peak=>ValueFlow.dollars_per_month(26.13/kperd),
         :md_off=>ValueFlow.dollars_per_month(13.07/kperd),
         :energy_peak=>EnergyValue.dollars_per_kilowatt_hour(0.17/kperd),
         :energy_offpeak=>EnergyValue.dollars_per_kilowatt_hour(0.13/kperd),
         :fixed=>ValueFlow.dollars_per_month(273.62/kperd)}

    #20001-7500
    md3={:name=>"MD3",:md_peak=>ValueFlow.dollars_per_month(41.75/kperd),
         :md_off=>ValueFlow.dollars_per_month(20.87/kperd),
         :energy_peak=>EnergyValue.dollars_per_kilowatt_hour(0.14/kperd),
         :energy_offpeak=>EnergyValue.dollars_per_kilowatt_hour(0.11/kperd),
         :fixed=>ValueFlow.dollars_per_month(579.74/kperd)}

    @peak_demand=energy_demand*peak_demand_over_average
    @peak_kVA=(peak_demand.kilowatts.value/power_factor).value


    if peak_kVA<=16
      @tarrif='C1'
      @energy_cost=energy_demand*EnergyValue.dollars_per_kilowatt_hour(0.31)
      @demand_cost=ValueFlow.dollars_per_month(0)
      @fixed_charge=ValueFlow.dollars_per_month(55.09)

    else
      case
        when peak_kVA>16 && peak_kVA<=300
          costs=md1
        when peak_kVA>300 && peak_kVA<=2000
          costs=md2
        else
          costs=md3
      end
      @tarrif=costs[:name]
      @energy_cost=energy_demand*costs[:energy_peak]*(1-off_peak_proportion)+energy_demand*costs[:energy_offpeak]*(off_peak_proportion)
      @demand_cost=peak_kVA*costs[:md_peak]*(1-off_peak_proportion)+peak_kVA*costs[:md_off]*(off_peak_proportion)
      @fixed_charge=costs[:fixed]
    end

    @excise_cost=(@fixed_charge+@demand_cost+@energy_cost)*excise
    @total_cost=@fixed_charge+@demand_cost+@energy_cost+@excise_cost
    @resulting_energy_cost=@total_cost/energy_demand

  end
end