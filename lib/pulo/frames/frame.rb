require 'csv'
require 'descriptive_statistics'
require_relative 'frame_cell'
require_relative 'frame_row'
require_relative 'frame_column'

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

    def import_csv path

    end

    def export_csv path

      CSV.open(path, 'wb') do |csv|
        csv << @columns.map {|col| col.name}
        csv << @columns.map {|col| col.column_class.name}
        @rows.each do |row|
          csv<<row.to_a
        end
      end
    end

    #applies the given function to each row
    #returns a hash where each element (keyed by the group) is a frame containing the group
    def group group_function
      groups={}
      @rows.each do |row|
        res=group_function.call(row)
        if groups[res]
          groups[res].append_row(row.to_a)
        else
          frm=self.copy_definition
          frm.append_row(row.to_a)
          groups.merge!({res=>frm})
        end
      end
      groups
    end

    def group_reduce group_function,column_defns
      groups=group(group_function)

      output=Frame.new
      output.append_column 'Group'
      column_defns.keys.each do |col|
        output.append_column(col)
      end
      groups.each do |group|
        row=column_defns.map do |defn|
          defn[1].call group[1]
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

    def clone
      frame=copy_definition
      @rows.each do |row|
          frame.append_row row.to_a
      end
      frame
    end

    def copy_definition
      frame=Frame.new
      @columns.each do |col|
        frame.append_column(col.name,col.hidden?,&col.formula)
      end
      frame
    end

    def delete_column(name_or_index)
      if name_or_index.is_a?(Integer)
        raise IndexError,"No column number #{name_or_index} defined." unless @columns[name_or_index]
        index=name_or_index
        name=@columns[index].name
      else
        index=@column_names[name_or_index]
        raise IndexError,"Column with name '#{name_or_index}' not found." unless index
        name=name_or_index
      end
      @rows.each {|row| row.delete_column(index)}
      @column_names.delete(name)
      @column_names.each do |item|
        @column_names[item[0]]-=1 if @column_names[item[0]]>=index
      end
      @columns.delete_at(index)
      @column_count-=1
    end

    def rename_column(old_name,new_name)
      col=self[old_name]
      col_no=@column_names[old_name]
      @column_names.delete(old_name)
      @column_names.merge!({new_name=>col_no})
      col.name=new_name
    end

    def append_column(name,hidden=false,&formula)
      col=FrameColumn.new(name,self, hidden, &formula)

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
          if values.length==column_count
            v = vals.next
          else
            v = col.value_column? ? vals.next : nil
          end
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
          if values.length==column_count
            v = vals.next
          else
            v = col.value_column? ? vals.next : nil
          end
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
      if column.is_a?(Integer)
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
      ret="\n          "
      ret+=@columns.select {|c| !c.hidden?}.map{|s| s.name.ljust(s.width,' ')}.join('  ') + "\n"
      ret+='========= '
      ret+=@columns.select {|c| !c.hidden?}.map{|s| "".ljust(s.width,'=')}.join('= ') + "\n"
      ret+='          '
      ret+=@columns.select {|c| !c.hidden?}.map{|s|
        if s.column_class.respond_to?(:quantity_name)
          (s.column_class.quantity_name + (s.value_column? ? '' : '*')).ljust(s.width,' ')
        else
          (s.column_class.to_s + (s.value_column? ? '' : '*')).ljust(s.width,' ')
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