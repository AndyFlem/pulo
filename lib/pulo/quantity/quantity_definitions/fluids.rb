# encoding: utf-8

module Pulo

  QuantityBuilder.build(:DynamicViscosity) do
    dimensions M:1,L:-1,T:-1

    si_unit :millipascal_second,:s, 'mPa.s',10**-3
    si_unit :pascal_second,:s, 'Pa.s',1
    si_unit :kilopascal_second,:s, 'kPa.s',10**3

    synonyms :Viscosity
  end

  QuantityBuilder.build(:KinematicViscosity) do
    dimensions L:2,T:-1

    si_unit :millistoke,:s, 'mSt',10**-7
    si_unit :centistoke,:s, 'cSt',10**-6
    si_unit :stoke,:s, 'St',10**-4
  end

end