require 'descriptive_statistics'

module Pulo
  class FrameColumn

    attr_reader :name,:formula,:column_number,:recalc_required, :formatter
    attr_accessor :width,:column_class

    def initialize(name,parent_frame,column_number,hidden,&formula)
      @name=name
      @column_number=column_number
      @parent_frame=parent_frame
      @formula=formula
      @cells=[]
      @recalc_required=block_given?
      @value_column=!block_given?
      @formatter=lambda {|v| v.to_s }
      @hidden=hidden
      @width=3
    end

    def formatter= (lamb)
      @formatter=lamb
    end
    def hidden?
      @hidden
    end
    def hidden=value
      @hidden=value
    end
    def type
      value_column? ? 'value' : 'formula'
    end
    def name= new_name
      if @parent_frame.column_names[new_name]
        @name=new_name
      else
        @parent_frame.rename_column @name,new_name
      end
    end

    def append_row(cell)
      @cells<<cell
    end
    def insert_row(row_no,cell)
      @cells.insert(row_no,cell)
    end

    def values=(vals)
      raise ArgumentError,"Wrong number of values given for column - need an array of #{@cells.count}" unless vals.count==@cells.count
      vals.each_with_index do |val,index|
        @cells[index].value=val
      end
    end

    def recalc
      @column_class=nil
      @parent_frame.rows.each do |row|
        begin
          row[@column_number].value=@formula.call(row)
        rescue Exception => e
          warn "Warning! Exception '#{e}' occured calculating column: #{@name} row: #{row.row_number}"
          row[@column_number].set_error
        end
      end
      @recalc_required=false
    end

    def [](index)
      raise IndexError,"No row number #{index} defined." unless @cells[index]
      @cells[index]
    end

    def lookup(value)
      (@cells.find_all {|cell| cell.value==value}).map {|cell| cell.row}
    end

    def map!(&block)
      @cells.each {|cell| cell.value=block.call(cell.value)}
    end

    def to_a
      @cells.map {|cell| cell.value}
    end

    def value_column?
      @value_column
    end

    def index?
      @is_index
    end

    def recalc_required?
      @recalc_required
    end

    def recalc_width
      @width=@cells.take(30).map {|c| c.to_s.length}.max
      @width||=0
      @width=[@width,@name.length].max
    end

    def to_s
      "#{@name}: #{(@cells.map {|c| c.to_s}).join(', ')}"
    end
    def inspect
      "Frame Column Object"
    end

  end
end