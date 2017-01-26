# encoding: utf-8

require_relative '../../spec/spec_helper'

module Pulo

  describe Tables do

      it 'should be listabe' do
        tables=Tables.list
        expect(tables.class).to eq(Array)
        expect(tables[0]).to eq('Densities')
      end
      it 'should be allow to get an item by name' do
        d=Densities.Gold
        expect(d.to_s).to eq("Density: 19,290 kg.m⁻³")
      end
      it 'should throw an error if an item is not found' do
        expect{ Densities.Goldxxx }.to raise_error(RuntimeError)
      end
      it 'should allow conversion to string' do
        expect(Densities.to_s.class).to eq(String)
      end
      it 'should allow conversion to array' do
        a=Densities.to_a
        expect(a.class).to eq(Array)
        expect(a[0][0]).to eq(:ABS)
      end
      it 'should allow find by name' do
        l=Densities.find('Lead')
        puts l[:Bronze_lead]
        #expect(Densities.to_s.class).to eq(String)
      end

  end
end
