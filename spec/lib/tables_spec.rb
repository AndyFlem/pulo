# encoding: utf-8

require_relative '../../spec/spec_helper'

module Pulo

  describe Tables do

      it 'should be listabe' do
        tables=Tables.list
        expect(tables.class).to eq(Array)
        expect(tables[0]).to eq('Densities')
      end
      it 'should give the table quantity and units' do
        expect(Densities.unit).to eq(:kilogram_per_cubic_meter)
        expect(Densities.quantity).to eq(Pulo::Density)
      end
      it 'should be allow to get an item by name' do
        d=Densities.Gold
        expect(d.to_s).to eq("Density: 19,290 kg.m⁻³")
      end
      it 'should throw an error if an item is not found' do
        expect{ Densities.Goldxxx }.to raise_error(RuntimeError)
      end
      it 'should allow conversion to array' do
        a=Densities.to_a
        expect(a.class).to eq(Array)
        expect(a[0][0]).to eq(:ABS)
        expect(a[0][1].class).to eq(Densities.quantity)
      end
      it 'should allow conversion to hash' do
        a=Densities.to_h
        expect(a.class).to eq(Hash)
        expect(a[:Zylon].value).to eq(1560.0)
      end
      it 'should allow find by name' do
        l=Densities.find('Lead')
        expect(l[:Bronze_lead].value).to eq(8200.0)
      end
      it 'should pass anything unrecognised to the underlying hash' do
        expect(Densities.values.max).to eq(22650)
        expect(Densities.max).to eq([:Zylon, 1560])
      end
      it 'should allow sort and sort reverse' do
        a=Densities.sort
        expect(a.class).to eq(Array)
        expect(a[0][0]).to eq(:Air)
        expect(a[0][1].class).to eq(Densities.quantity)
        a=Densities.sort_reverse
        expect(a[0][0]).to eq(:Iridium)
      end

      it 'should allow conversion to yaml' do
        y=Densities.to_yaml
        expect(y.class).to eq(String)
      end

      it 'should allow to add and remove items' do
        Densities.add_item('Test',0)
        expect(Densities.Test).to eq(Density.kilograms_per_cubic_meter(0))
        Densities.remove_item('Test')
      end

  end
end
