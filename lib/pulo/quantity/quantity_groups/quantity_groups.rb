# encoding: utf-8

module Pulo

  module QuantityGroups
  US_THERMO={
      Energy: :millions_btu,
      SpecificEnthalpy: :btu_per_pound,
      SpecificEntropy: :btu_per_pound_rankine,
      Pressure: :psig,
      Temperature: :fahrenheit,
      SpecificVolume: :cubic_feet_per_pound,
      Volume: :cubic_feet,
      Mass: :pounds,
      MassFlow: :pounds_per_hour
  }
  METRIC_THERMO={
      Energy: :megawatts,
      SpecificEnthalpy: :kilojoules_per_kilogram,
      SpecificEntropy: :kilojoules_per_kilogram_kelvin,
      Pressure: :kilopascals,
      Temperature: :kelvin,
      SpecificVolume: :cubic_meters_per_kilogram,
      Volume: :cubic_meters,
      Mass: :kilograms,
      MassFlow: :kilograms_per_hour
  }
  IRRIGATION={
      Area: :hectares,
      Mass: :tonnes,
      Volume: :cubic_meters
  }

  end

end