[![Build Status](https://travis-ci.org/AndyFlem/pulo.svg?branch=master)](https://travis-ci.org/AndyFlem/pulo)
[![Coverage Status](https://coveralls.io/repos/github/AndyFlem/pulo/badge.svg?branch=master)](https://coveralls.io/github/AndyFlem/pulo?branch=master)

# Pulo

Pulo is a (back-of-envelope) calculator for engineering. It:

 - understands physical quantities, their dimensions and units which are all defined in a DSL (based on the metric system but with conversions to/from other systems).

 - determines the quantities resulting from calculation based on the dimensions of operands (eg `Length * Length = Area`, `Area * Length = Volume`).

 - allows for the definition and use of constants eg `Acceleration.g`

 - contains objects for working with simple 2D and 3D figures (`Circle`, `Triangle`, `Cylinder`, `Cube`)

 - has `Frames` which are spreadsheet-like grids with columns that can contain simple values, quantities or calculations based on other columns

 - Includes tables eg `Densities` listing quantities

 - contains 'machine' definitions - eg `Pipe` and `Boiler`

 - contains 'material' definitions - eg `Water`

 - It contains built in steam table calculators (IF97).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pulo'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pulo

## Usage
The first example assumes **pulo** has been `required` and then classes are qualified with the Pulo:: module. Later examples assume execution within the context of the module (eg using [Pry](https://github.com/pry/pry) `cd Pulo`)  so the qualifier can be dropped.

### Simple Example
```ruby
#This example calculates the power (in gigawatt hours per year) of a hydro turbine based on head, flow and efficiency

(
    Pulo::Head.inches(1000)*
    Pulo::VolumeFlow.cumec(150)*
    Pulo::Acceleration.g*
    Pulo::Density.water*
    Pulo::Efficiency.percent(90)
).gigawatt_hours_per_year.to_s

#Power: 294.57 GW.hr.yr-1
```

### Quantities and Units
To get a list of available quantities and units use Pulo.help. For example part of the output will be similar to:

*Pressure, EnergyDensity, VolumeEnergyDemand, Stress, TensileStrength, YieldStrength*
`[M.L⁻¹.T⁻²]`
 - Pa, pascal, pascals, *10^0.0
 - kPa, kilopascal, kilopascals, *10^3.0
 - MPa, megapascal, megapascals, *10^6.0
 - bar, bar, bar, 0.01 per kilopascal
 - psia, pounds_per_square_inch, psia, 0.145 per kilopascal
 - psig, pounds_per_square_inch_gauge, psig, 0.145 per kilopascal
 - inHg, inch_of_mercury, inches_of_mercury, 0.2953 per kilopascal
 - tor, torr, torr, 7.5006 per kilopascal
 - more

First a list of synonyms for this quantity are given followed by the quantity definition by its [dimensions](https://en.wikipedia.org/wiki/Dimensional_analysis) (Mass.Length⁻¹.Time⁻²)

Following this are a list units which can be used for this quantity starting with [SI units](https://en.wikipedia.org/wiki/International_System_of_Units) and then followed by units in other systems. Each SI unit includes its scale compared to the first (base) unit.

Non SI Units include a conversion factor to an SI unit of a reasonably equivalent scale.

Each unit has abbreviated (MPa), singular (megapascal) and plural versions (megapascals) which are all class methods on the quantity class with can be referred to by any of its synonyms.

For example a pressure quantity can be instantiated as one unit and converted to any other unit of the same quantity:
```ruby
p=Pressure.inHg(2).pascals
p.to_s
=> "Pressure: 6,772 Pa"
```

###Calculations on Dimensions
Every quantity in **pulo** has an associated dimension eg SpecificHeat - [L².K⁻¹.T⁻²]. The dimensions currently used are:

 - **L** - Length
 - **M** - Mass
 - **T** - Time
 - **K** - Temperature
 - **I** - Current
 - **V** - Value

Any calculation involving quantities is inspected to determine the resulting dimensions and where these are recognized then the result is *'cast'* into the quantity corresponding to these dimensions:
```ruby

```


## Contributing

1. Fork it ( https://github.com/AndyFlem/pulo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
