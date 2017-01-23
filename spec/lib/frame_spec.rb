# encoding: utf-8

require_relative '../../spec/spec_helper'

module Pulo

  describe Frame do

    describe 'building a frame from simple columns and accessing columns, rows and cells' do
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
        @frame['Note'].values=['Apples','Pears','Oranges','Grapes']
        expect(@frame.column_count).to eq(3)
        expect(@frame[2][1]).to be_an_instance_of FrameCell
        expect(@frame[2][1].value).to eql('Pears')
      end

      it 'should raise exceptions for out of bounds and not found columns and rows' do
        expect{ @frame[100] }.to raise_error(IndexError)
        expect{ @frame['XXX'] }.to raise_error(IndexError)
        expect{ @frame.rows[1][100] }.to raise_error(IndexError)
        expect{ @frame.rows[1]['XXX'] }.to raise_error(IndexError)
        expect{ @frame[1][100] }.to raise_error(IndexError)
        expect{ @frame['Note'].values=['Apples','Pears','Oranges'] }.to raise_error(ArgumentError)
      end
      it 'should allow to add a calculation column' do
        @frame.append_column('Note_Length') do |row|
          row['Note'].value.length
        end
        @frame.recalc_all
        expect(@frame['Note_Length'][0].value).to eql(6)
      end
      it 'should set cell value to ERR if  ' do
        @frame.append_column('Another_Calc') do |row|
          1/row['Count'].value
        end
        @frame.recalc_all

      end

      it 'should convert to string' do
        expect(@frame.rows[1].to_s).to eql('row 1:    2    0    Pears  5    ERR')
        expect(@frame.columns[0].to_s).to eql('Id: 1  , 2  , 3  , 4  ')
        expect(@frame.to_s).to be_an_instance_of String
      end
    end

  end
end

