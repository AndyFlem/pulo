[![Build Status](https://travis-ci.org/AndyFlem/pulo.svg?branch=master)](https://travis-ci.org/AndyFlem/pulo)
[![Coverage Status](https://coveralls.io/repos/AndyFlem/pulo/badge.svg?branch=master&service=github)](https://coveralls.io/github/AndyFlem/pulo?branch=master)

# Pulo

Pulo is a (back-of-envelope) calculator for engineering. It:

 - understands physical quantities, their dimensions and units which are all defined in a DSL (based on the metric system but with conversions to/from other systems).

 - determines the quantities resulting from calculation based on the dimensions of operands (eg `Length * Length = Area`, `Area * Length = Volume`).

 - allows for the definition and use of constants eg `Acceleration.g`

 - contains objects for working with 2D and 3D figures (`Circle`, `Triangle`, `Cylinder`, `Cube`)

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

```ruby
#This example calculates the power (in gigawatt hours per year) of a hydro power station based on head, flow and efficiency

puts (
    Head.centimeters(1000)*
    VolumeFlow.cumec(150)*
    Acceleration.g*
    Density.water*
    Efficiency.percent(90)
  ).gigawatt_hours_per_year.to_s

#Power: 115.97 GW.hr.yr-1
```

## Contributing

1. Fork it ( https://github.com/AndyFlem/pulo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
