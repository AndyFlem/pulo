module Pulo

  class Frame

    class << self
      def aggregate groups, column_defns
      end
    end


    attr_reader :column_count,:row_count,:rows, :columns, :column_names

    def initialize

      @rows=[]
      @columns=[]
      @column_names={}
      @column_count=0
      @row_count=0
    end

    #applies the given function to each row
    #returns a hash where each element (keyed by the group) is an array of frame_rows making up a group
    def group group_function,column_defns
      groups={}
      @rows.each do |row|
        res=group_function.call(row)
        if groups[res]
          groups[res].append_row(row.to_a_values)
        else
          frm=self.copy_definition
          frm.append_row(row.to_a_values)
          groups.merge!({res=>frm})
        end
      end

      output=Frame.new
      output.append_column 'Group'
      column_defns.keys.each do |col|
        output.append_column(col)
      end
      groups.each do |group|
        row=column_defns.map do |defn|
          defn[1][1].call group[1][defn[1][0]].to_a
        end
        row.insert 0,group[0]
        output.append_row row
      end
      output

    end

    def sort(&sort_function)
      int=@rows.map do |row|
        [row.row_number,sort_function.call(row)]
      end.sort_by {|elm| elm[1]}.map{|elm| elm[0]}
      frm=self.copy_definition
      int.each do |row_no|
        frm.append_row self.rows[row_no].to_a_values
      end
      frm
    end

    def copy_definition
      frame=Frame.new
      @columns.each do |col|
        frame.append_column(col.name,col.hidden?,&col.formula)
      end
      frame
    end


    #def load_from_spreadsheet(path, sheet,procs=[])
    #  #sheet=Roo::CSV.new(path)
    #  dat=ExcelWrapper.load(path,sheet)
    #  head=dat.first
    #  body=dat.drop(1)
    #  head.each do |col|
    #    if col.respond_to?(:strip)
    #      append_column(col.strip)
    #    end
    #  end
    #  procs.fill(lambda {|n| n},procs.length..(head.length-1))
    #  body.each_with_index do |row,i|
    #    calculated=row.zip(procs).map do |d,p|
    #      begin
    #        p.call(d)
    #      rescue Exception => e
    #        warn "Warning! Exception '#{e}' importing row #{i} from spreadsheet on value #{d.class}:'#{d.to_s}'."
    #      end
    #    end
    #    append_row(calculated)
    #  end
    #end

    def delete_column(name)
      column_no=@column_names[name]
      @rows.each {|row| row.delete_column(column_no)}
      @column_names.delete(name)
      @columns.delete_at(column_no)
    end

    def rename_column(old_name,new_name)
      col=self[old_name]
      @column_names.delete(old_name)
      @column_names.merge!({new_name=>col.column_number})
      col.name=new_name
    end

    def append_column(name,hidden=false,&formula)
      col=FrameColumn.new(name,self,@column_count, hidden, &formula)

      @columns << col
      @column_names.merge!({name=>@column_count})

      for i in 0..(@row_count-1)
        rw=@rows[i]
        cell=FrameCell.new(col,rw)
        col.append_row(cell)
        rw.append_column(cell)
      end
      @column_count+=1
      col
    end

    def append_row(values)
      if values.is_a?(Array)
        vals=values.each
        row=FrameRow.new(self,@row_count)
        @columns.each do |col|
          v = col.value_column? ? vals.next : nil
          cell=FrameCell.new(col,row,v)
          col.append_row(cell)
          row.append_column(cell)
        end
        @rows<<row
        @row_count+=1
        row
      else
        raise "Expecting an array of values as the append row."
      end
    end
    def insert_row(previous_row,values)
      if values.is_a?(Array)
        row_no=previous_row.row_number+1
        vals=values.each
        row=FrameRow.new(self,row_no)
        @columns.each do |col|
          v = col.value_column? ? vals.next : nil
          cell=FrameCell.new(col,row,v)
          col.insert_row(row_no,cell)
          row.append_column(cell)
        end
        @rows.insert(row_no,row)
        @row_count+=1
        @rows.drop(row_no+1).each {|r| r.row_number+=1}
      else
        raise "Expecting an array of values as the append row."
      end
    end

    def recalc_all
      formula_columns.each { |col| col.recalc }
    end

    def [](column)
      if column.is_a?(Fixnum)
        raise IndexError,"No column number #{column} defined." unless @columns[column]
        @columns[column]
      else
        column_no=@column_names[column]
        raise IndexError,"Column with name '#{column}' not found." unless column_no
        @columns[column_no]
      end
    end

    def first_row
      @rows.first
    end
    def last_row
      @rows.last
    end

    def lookup(value,column)
      self[column].lookup(value)
    end

    def to_s &filter
      @columns.each {|c| c.recalc_width}
      ret='          '
      ret+=@columns.select {|c| !c.hidden?}.map{|s| s.name.ljust(s.width,' ')}.join('  ') + "\n"
      ret+='========= '
      ret+=@columns.select {|c| !c.hidden?}.map{|s| "".ljust(s.width,'=')}.join('= ') + "\n"
      ret+='          '
      ret+=@columns.select {|c| !c.hidden?}.map{|s|
        if s.type=='value'
          if s.column_class.respond_to?(:quantity_name)
            s.column_class.quantity_name.ljust(s.width,' ')
          else
            s.column_class.to_s.ljust(s.width,' ')
          end

        else
          s.type.ljust(s.width,' ')
        end

      }.join('  ') + "\n"
      ret+='--------- '
      ret+=@columns.select {|c| !c.hidden?}.map{|s| "".ljust(s.width,'-')}.join('- ') + "\n"

      ret+=(@rows.select{|row| !block_given? || filter.call(row)}.map { |row| row.to_s}).join("\n")

      ret+="\n" + @rows.length.to_s + " rows\n"
      ret
    end

    def inspect
      "Frame Object"
    end

    def value_columns
      @columns.find_all { |col| col.value_column?}
    end

    def formula_columns
      @columns.find_all { |col| !col.value_column?}
    end

  end
end