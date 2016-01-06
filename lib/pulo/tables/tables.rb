module Pulo
  module Tables
    @tables=[]
    def self.included base
      base.send :include, InstanceMethods
      base.extend ClassMethods
      @tables << base.name.split('::')[1]
      base.send :load_yaml
    end
    def self.list
      @tables
    end
    module InstanceMethods
    end
    module ClassMethods
        def method_missing(method_sym, *arguments, &block)
          if @values[method_sym]
            @quantity.new(@values[method_sym],@unit)
          else
            raise "Can't find item '#{method_sym}' in table #{self.name.split('::')[1]}."
          end
        end
        def find value
          search_value=value.downcase
          @values.select { |key, value| key.to_s.downcase.include? search_value }
        end
        def to_s
          @values.to_s
        end
        def to_a
          @values.to_a
        end
        def to_sorted
          @values.sort_by {|k,v| v}
        end
        def to_sorted_reverse
          @values.sort_by {|k,v| -v}
        end

        def to_frame
          frm=Frame.new
          frm.append_column('Item')
          frm.append_column(@quantity.quantity_name)
          @values.to_a.each do |ar|
            frm.append_row([ar[0],self.send(ar[0],ar[1])])
          end

          frm
        end
        def to_yaml
          @values.to_yaml
        end
        def save_yaml
          File.write(File.join(__dir__,'table_data', self.name.split('::')[1] + '.yaml'),self.to_yaml)
        end
        def load_yaml
          @values=YAML.load_file(File.join(__dir__,'table_data', self.name.split('::')[1] + '.yaml'))
        end
        def add_item(key,value)
          key=key.to_s.gsub(/\s+/,"_").to_sym unless key.is_a?(Symbol)
          @values.merge!({key=>value})
          self.save_yaml
        end
        def remove_item(key)
          key=key.to_s.gsub(/\s+/,"_").to_sym unless key.is_a?(Symbol)
          @values.delete(key)
          self.save_yaml
        end
    end

  end
end

require_relative 'density'
require_relative 'melting_temperature'