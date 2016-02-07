# encoding: utf-8

module Pulo

QuantityBuilder.build(:Current) do
  dimensions I:1
  si_unit :amp,:s, 'A',1
  si_unit :milliamp,:s, 'mA',10**-3
  si_unit :microamp,:s, 'μA',10**-6
end

QuantityBuilder.build(:Resistance) do
  dimensions M:1,L:2,T:-3,I:-2
  si_unit :ohm,:s, 'Ω',1
end

QuantityBuilder.build(:Voltage) do
  dimensions M:1,L:2,T:-3,I:-1
  si_unit :volt,:s, 'V',1
end

end