module Pulo
  class FrameCell

    def initialize(parent_column,parent_row,value=nil)
      @parent_column=parent_column
      @parent_row=parent_row
      @error=false
      self.value=value
    end

    def column
      @parent_column
    end

    def row
      @parent_row
    end

    def empty?
      @value.nil?
    end

    def value_column?
      @parent_column.value_column?
    end

    def set_error
      @error=true
    end
    def unset_error
      @error=false
    end
    def error?
      @error
    end

    def value
      #raise "Column (#{@parent_column.name}) requires re-calc, value not available." if @parent_column.recalc_required
      return "ERR" if error?
      #return "UNK" if @parent_column.recalc_required
      #return "NIL" if empty?
      @value
    end

    def value=(val)

      if @parent_column.column_class==NilClass
        @parent_column.column_class=val.class
        if val.class.respond_to?(:quantity_name)
          @parent_column.column_unit=val.unit
        end
      end

      if val.class.respond_to?(:quantity_name)
        if val.unit.name!=@parent_column.column_unit.name
          val=val.send(@parent_column.column_unit.name)
        end
      end

      #if @parent_column.column_class!=NilClass && val.class!=NilClass
      #  if val.class.respond_to?(:quantity_name)
      #    unless val.class.dimensions==@parent_column.column_class.dimensions
      #      raise "Tried to set a value (#{val.to_s}) of class #{val.class} with dimensions #{val.class.dimensions} on column #{@parent_column.name} which already has a defined class of #{@parent_column.column_class}."
      #    end
      #  else
      #    unless val.class==@parent_column.column_class
      #      raise "Tried to set a value (#{val.to_s}) of class #{val.class} on column #{@parent_column.name} which already has a defined class of #{@parent_column.column_class}."
      #    end
      #  end
      #end
      @value=val
    end

    def to_s
      begin
        @parent_column.formatter.call(value).ljust(@parent_column.width,' ')
      rescue Exception => e
        value.to_s
      end
    end

  end
end