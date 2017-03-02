require 'descriptive_statistics'

module Pulo
  class FrameColumn

    attr_reader :name,:formula, :formatter, :column_class, :column_unit
    attr_accessor :width

    def initialize(name,parent_frame,hidden,&formula)
      @name=name
      @parent_frame=parent_frame
      @formula=formula
      @cells=[]
      #@recalc_required=block_given?
      @value_column=!block_given?
      @standard_formatter=lambda {|v| v.to_s }
      @formatter=@standard_formatter
      @hidden=hidden
      @width=3
      @column_class=NilClass
      @column_unit=NilClass
    end

    def set_formula &formula
      @formula=formula
      #@recalc_required=true
      @value_column=false
    end

    def column_number
      @parent_frame.column_names[@name]
    end

    def column_class= (klass)
      @column_class=klass
      if @column_class.respond_to?(:quantity_name) and @formatter==@standard_formatter
        @formatter=lambda {|q| q.to_s(nil,true)}
      end
    end
    def column_unit=(klass)
      @column_unit=klass
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

    def recalc with_timing=false
      t_start=Time.now

      @column_class=NilClass
      @parent_frame.rows.each do |row|
        begin
          row[column_number].value=@formula.call(row)
          row[column_number].unset_error
        rescue Exception => e
          #raise "Exception '#{e}' occured calculating column: #{@name} row: #{row.row_number}"
          warn "Warning! Exception '#{e}' occured calculating column: #{@name} row: #{row.row_number}"
          row[column_number].set_error
        end
      end

      if with_timing
        puts "Recalc column '#{@name}' in: #{((Time.now-t_start)*1000).to_i} ms."
      end
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

    def recalc_width
      @width=@cells.take(30).map {|c| c.to_s.length}.max
      @width||=0
      @width=[@width,@name.length].max
      @width=[@width,column_class.to_s.length+1].max
    end

    def to_s
      "#{@name}: #{(@cells.map {|c| c.to_s}).join(', ')}"
    end
    def inspect
      "Frame Column Object"
    end

    def descriptive_statistics
      vals=self.to_a
      if @column_class.respond_to?(:quantity_name)
        vals=vals.map{|val| val.send(@column_unit.name).value}
      end
      stats=vals.descriptive_statistics
      if @column_class.respond_to?(:quantity_name)
        stats.map{|val|

          if val[0]!=:number
            [val[0],@column_class.new(val[1],@column_unit)]
          else
            [val[0],val[1]]
          end

        }.to_h
      end
    end

  end
end