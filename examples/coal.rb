
require_relative '../lib/pulo'

module Pulo
    def self.pFixed(one, two) 
        puts "#{one.ljust(30)} #{two}"
    end

    calorifics = [[6000, 0.42],[5500, 0.4], [5000, 0.38], [4500, 0.36], [4000, 0.34], [3500, 0.32]]

    calorifics.each do |calorific|

        plant_capacity = Power.megawatts(350)
        coal_calorific_value = SpecificEnergy.kilocalorie_per_kilogram(calorific[0])
        coal_feed_rate = MassFlow.tonnes_per_hour(115)

        input_power = coal_calorific_value * coal_feed_rate

        plant_efficiency = Dimensionless.n(calorific[1])
        boiler_efficiency = Dimensionless.n(0.9)
        overall_efficiency = plant_efficiency * boiler_efficiency

        output_power = input_power * overall_efficiency

        output_specific_energy = coal_calorific_value * overall_efficiency

        fuel_requirement = 1 / output_specific_energy
        
        gross_annual_energy = output_power * Period.hour(24*365)

        plant_availability_factor = Dimensionless.n(0.75)
        plant_unavailability_factor = 1 - plant_availability_factor
        transformer_losses = Dimensionless.n(0.006)
        parasitic_power = Dimensionless.n(0.01)
        losses = plant_unavailability_factor + transformer_losses + parasitic_power
        
        net_annual_energy = gross_annual_energy * (1-losses)
        
        capacity_factor = net_annual_energy / (plant_capacity * Period.hour(24*365))

        annual_fuel_consumption = coal_feed_rate * Period.hour(24*365) * plant_availability_factor
        monthly_fuel_consumption = annual_fuel_consumption / 12

        puts '#############################################################'
        pFixed 'Coal Calorific Value', coal_calorific_value.to_s
        pFixed 'Plant Efficiency', plant_efficiency.percent.to_s
        puts '-------------------------------------------------------------'
        pFixed 'Fuel Specific Energy', coal_calorific_value.kilowatt_hour_per_kilogram.to_s
        pFixed 'Coal Feed Rate', coal_feed_rate.to_s
        pFixed 'Input Power', input_power.megawatts.to_s
        pFixed 'Overall Efficiency', overall_efficiency.percent.to_s 
        pFixed 'Output Power', output_power.megawatts.to_s
        pFixed 'Output Specific Energy', output_specific_energy.kilowatt_hour_per_kilogram.to_s
        pFixed 'Fuel Requirement', fuel_requirement.kilogram_per_kilowatt_hour.to_s
        pFixed 'Gross Annual Energy', gross_annual_energy.gigawatt_hour.to_s
        pFixed 'Losses', losses.percent.to_s
        pFixed 'Net Annual Energy', net_annual_energy.gigawatt_hour.to_s
        pFixed 'Capacity Factor', capacity_factor.percent.to_s 
        pFixed 'Annual Fuel Consumption', annual_fuel_consumption.tonnes.to_s
    end

end