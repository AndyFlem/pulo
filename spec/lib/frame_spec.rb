# encoding: utf-8

require_relative '../../spec/spec_helper'

module Pulo

  describe Frame do

    describe 'Frame' do
      before :all do
        @frame=Frame.new()
      end
      it 'should allow columns to be defined by name' do
        fr=@frame.append_column('Id')
        @frame.append_column('Count')

        expect(@frame.column_count).to eq(2)
      end
      it 'should allow rows to be added as arrays of values' do
        @frame.append_row([1,1])
        @frame.append_row([2,0])
        @frame.append_row([3,400])
        @frame.append_row([4,400])
        expect(@frame.row_count).to eq(4)
      end

      it 'should return a column by name' do
        col=@frame['Count']
        expect(col).to be_an_instance_of FrameColumn
      end
      it 'should return a column by index number' do
        col=@frame[1]
        expect(col).to be_an_instance_of FrameColumn
        col2=@frame.columns[1]
        expect(col2).to be_an_instance_of FrameColumn
      end
      it 'should return a cell by from a column with row index' do
        cell=@frame['Count'][2]
        expect(cell).to be_an_instance_of FrameCell
        expect(cell.value).to eql(400)
      end

      it 'rows should supply next_row and Previous_row' do
        row=@frame.rows[2]
        expect(row.next_row).to be_an_instance_of FrameRow
        expect(row.previous_row).to be_an_instance_of FrameRow
      end

      it 'rows should supply enumerators for next_rows and previous_rows' do
        row=@frame.rows[2]
        nr_en=row.next_rows
        pr_en=row.previous_rows

        expect(nr_en).to be_an_instance_of Enumerator
        expect(pr_en).to be_an_instance_of Enumerator

        expect(nr_en.first).to be_an_instance_of FrameRow
        expect(pr_en.first).to be_an_instance_of FrameRow
      end

      it 'should look up rows based on the value of a named column' do
        rows=@frame.lookup(400,'Count')
        expect(rows.count).to eql(2)
        expect(rows[0].row_number).to eql(2)
      end

      it 'should return a cell based given an index on a row' do
        cell=@frame.rows[2][1]
        expect(cell).to be_an_instance_of FrameCell
        expect(cell.value).to eql(400)
      end

      it 'should allow a new column to be added to existing frame and fill with empty cells' do
        @frame.append_column('Note')
        expect(@frame.column_count).to eq(3)
        expect(@frame[2][1]).to be_an_instance_of FrameCell
        expect(@frame[2][1]).to be_empty
      end
      it 'should allow setting of values on the new column' do
        @frame['Note'].values=['Apples','Pears','Pears','Grapes']
        expect(@frame.column_count).to eq(3)
        expect(@frame[2][1]).to be_an_instance_of FrameCell
        expect(@frame[2][1].value).to eql('Pears')
        expect(@frame['Note'].column_class).to eql(String)
      end

      it 'should raise exceptions for out of bounds and not found columns and rows' do
        expect{ @frame[100] }.to raise_error(IndexError)
        expect{ @frame['XXX'] }.to raise_error(IndexError)
        expect{ @frame.rows[1][100] }.to raise_error(IndexError)
        expect{ @frame.rows[1]['XXX'] }.to raise_error(IndexError)
        expect{ @frame[1][100] }.to raise_error(IndexError)
        expect{ @frame['Note'].values=['Apples','Pears','Oranges'] }.to raise_error(ArgumentError)
        expect{ @frame['Note'][0].value=1 }.to raise_error(RuntimeError)
      end
      it 'should allow to add a calculation column' do
        @frame.append_column('Note_Length') do |row|
          row['Note'].value.length
        end
        @frame.recalc_all
        expect(@frame['Note_Length'][0].value).to eql(6)
      end
      it 'should set cell value to ERR if calc gives an err' do
        @frame.append_column('Another_Calc') do |row|
          1/row['Count'].value
        end
        @frame.recalc_all
      end
      it 'should throw exception for deleting with out of bounds index or column name not found' do
        expect {@frame.delete_column(10)}.to raise_error(IndexError)
        expect {@frame.delete_column('xxx')}.to raise_error(IndexError)
      end

      it 'should convert to string' do
        expect(@frame.rows[1].to_s).to eql('row 1:    2    0    Pears  5    ERR')
        expect(@frame.columns[0].to_s).to eql('Id: 1  , 2  , 3  , 4  ')
        expect(@frame.to_s).to be_an_instance_of String
      end

      it 'should allow deletion of an internal column' do
        @frame.delete_column(3)
        expect(@frame[3].name).to eql('Another_Calc')
        expect(@frame[3][2].value).to eql(0)
        expect(@frame.column_count).to eql(4)
      end
      it 'should allow adding a measure column' do
        @frame.append_column('MassVal').values=[Mass.kilograms(1),Mass.kilograms(10),Mass.kilograms(3),Mass.kilograms(1.4)]
        expect(@frame.column_count).to eql(5)
      end
      it 'should allow calculation on a measure column' do
        @frame.append_column('Density col') do |row|
          row['MassVal'].value/Volume.cubic_meters(0.1)
        end
        @frame.recalc_all

      end
      it 'should allow a custom formatter on a column' do
        @frame['Density col'].formatter=lambda {|q| q.kilograms_per_cubic_meter.to_s(nil,true)}
        expect(@frame['Density col'][1].to_s).to eql('100 kg.m⁻³')
      end
      it 'should allow to reset the formula on a column' do
        @frame['Another_Calc'].set_formula do |row|
          row['Count'].value+1
        end
        @frame.recalc_all
        expect(@frame['Another_Calc'][1].value).to eql(1)
      end
      it 'should allow a sort' do
        @sorted_frame=@frame.sort do |row|
          row['MassVal'].value
        end
        @sorted_frame.recalc_all
        expect(@sorted_frame['MassVal'][1].to_s).to eql('1.4 kg')
      end

      #rename column
      it 'should allow a column to be renamed' do
        @frame.rename_column('Another_Calc','Another Calculation')
        expect(@frame[3].name).to eql('Another Calculation')
        expect(@frame['Another Calculation'][0].value).to eql(2)
      end

      #insert row
      it 'should allow a row to be inserted' do
        @frame.insert_row(@frame.rows[1],[100,100,'Grapes',nil, Mass.kilograms(43),nil])
        @frame.recalc_all
        expect(@frame[3][2].value).to eql(101)
        puts @frame
      end

      #group
      it 'should allow grouping' do
        @groups=@frame.group(lambda {|row| row['Note'].value})
        expect(@groups['Pears'].row_count).to eql(2)

        @reduce=@frame.group_reduce(lambda {|row| row['Note'].value},{"Sum Count"=>lambda {|frame| frame['Count'].to_a.sum }})
        expect(@reduce.lookup('Pears','Group')[0]['Sum Count'].value).to eql(400)
        puts @reduce
      end

      #it 'should allow save to CSV' do
      #  @frame.export_csv(File.expand_path('../../temp/export.csv',__FILE__))
      #end

    end

  end
end

