require_relative '../lib/pulo'

module Pulo
  p Tables.list
  puts Densities.ABS
  #puts Densities.Aasd
  puts Densities.to_s
  p Densities.to_a
  p Densities.find('Lead')
  p Densities.to_sorted_reverse.first(5)

  p MeltingTemperatures.to_a

  puts MeltingTemperatures.to_frame

  p MeltingTemperatures.to_yaml
  MeltingTemperatures.save_yaml
  MeltingTemperatures.load_yaml
  p MeltingTemperatures.to_a

  #Densities.save_yaml

  #MeltingTemperatures.add_item('Bollocks',0)
  #puts MeltingTemperatures.Bollocks
  #MeltingTemperatures.remove_item('Bollocks')

end
