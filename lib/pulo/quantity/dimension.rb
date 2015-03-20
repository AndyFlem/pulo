# encoding: utf-8

module Pulo
  class Dimension
  include Comparable
  def initialize spec
    @spec=spec #hash keyed on dimension name as a symbol eg :L
    clean
  end
  def spec
    @spec
  end

  def is_base?
    @spec.count==1 && @spec.first[1]==1
  end

  def +(other_spec)
    Dimension.new @spec.merge(other_spec.spec) {|key,val1,val2| val1+val2}
  end
  def -(other_spec)
    new_hash = Hash[other_spec.spec.map{|k,itm| [k,-itm] } ]
    Dimension.new @spec.merge(new_hash) {|key,val1,val2| val1+val2}
  end
  def *(val)
    Dimension.new Hash[@spec.map{|itm| [itm[0],itm[1]*val]}]
  end
  def /(val)
    Dimension.new Hash[@spec.map{|itm| [itm[0],itm[1]/val]}]
  end

  def ==(other_spec)
    val=(@spec.merge(other_spec.spec) {|key,val1,val2| val1-val2}).inject(0) {|sum,n| sum+n[1].abs}
    val==0
  end
  def eql?(other_spec)
    self==(other_spec)
  end
  def hash
    @spec.to_s.hash
  end
  def to_s
    @spec.inject('') do |ret,item|
      ret+=item[0].to_s + item[1].to_s
    end
  end

  private

  def clean
    @spec=Hash[@spec.delete_if {|key,value| value==0}.sort]
  end
end
end