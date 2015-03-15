# encoding: utf-8
require 'spec_helper'

describe 'Setting up a table' do
  it 'should setup a table' do
    tab=CalcTable.new("Pipes")
    tab.add :irrigation_area do Area.hectares(450) end
    irrigation_demand=Precipitation.millimeters(850)
    pump_station_cost=Cost.dollars(300000)

  end
end