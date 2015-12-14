module Pulo
  class FrameRow
    attr_reader :cells
    attr_accessor :row_number
    def initialize(parent_frame, row_number)
      @cells=[]
      @parent_frame=parent_frame
      @row_number=row_number
    end

    def append_column(cell)
      @cells<<cell
    end

    def delete_column(index)
      @cells.delete_at index
    end

    def [](column)
      if column.is_a?(Fixnum)
        raise IndexError,"No column number #{column} defined." unless @cells[column]
        @cells[column]
      else
        @parent_frame[column][@row_number]
      end
    end

    def previous_rows
      Enumerator.new do |y|
        for i in (0..(@row_number-1)).reverse_each
          y.yield @parent_frame.rows[i]
        end
      end
    end

    def next_rows
      Enumerator.new do |y|
        for i in (@row_number+1)..@parent_frame.row_count-1
          y.yield @parent_frame.rows[i]
        end
      end
    end

    def previous_row
      if @row_number>0
        @parent_frame.rows[@row_number-1]
      else
        nil
      end
    end

    def next_row
      if @row_number<@parent_frame.row_count
        @parent_frame.rows[@row_number+1]
      else
        nil
      end
    end

    def to_s
      "row #{@row_number}:".ljust(9,' ') + " #{((@cells.select {|s| !s.column.hidden?}).map {|c| c.to_s}).join('  ')}"
    end
    def inspect
      "Frame Row Object"
    end

    def to_a
      @cells.map {|cell| cell.value}
    end

    def to_a_values
      value_cells.map {|cell| cell.value}
    end

    def value_cells
      @cells.find_all { |cell| cell.value_column?}
    end

    def to_h
      Hash[@parent_frame.column_names.keys.to_a.zip(to_a)]
    end

    def first_row?
      @row_number==0
    end
  end
end