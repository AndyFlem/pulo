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
      @parent_column.column_class=val.class if @parent_column.column_class==NilClass
      if val.class!=@parent_column.column_class && @parent_column.column_class!=NilClass && val.class!=NilClass
        raise "Tried to set a value of class #{val.class} on column #{@parent_column.name} which already has a defined class of #{@parent_column.column_class}."
      end
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