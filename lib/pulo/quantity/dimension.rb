# encoding: utf-8

module Pulo
  class Dimension
  include Comparable
  def initialize(spec)
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
    Dimension.new @spec.merge(other_spec.spec) {|_key,val1,val2| val1+val2}
  end
  def -(other_spec)
    new_hash = Hash[other_spec.spec.map{|k,itm| [k,-itm] } ]
    Dimension.new @spec.merge(new_hash) {|_key,val1,val2| val1+val2}
  end
  def *(val)
    Dimension.new Hash[@spec.map{|itm| [itm[0],itm[1]*val]}]
  end
  def /(val)
    Dimension.new Hash[@spec.map{|itm| [itm[0],itm[1]/val]}]
  end

  def ==(other_spec)
    val=(@spec.merge(other_spec.spec) {|_key,val1,val2| val1-val2}).inject(0) {|sum,n| sum+n[1].abs}
    val==0
  end
  def eql?(other_spec)
    self==(other_spec)
  end
  def hash
    @spec.to_s.hash
  end
  def to_s
    sort_spec=@spec.sort_by { |item| item[1]*-1}

    sort_spec.inject('') do |ret,item|
      exp=if item[1]!=1 then Pulo.super_digit(item[1]) else '' end
      ret+=item[0].to_s + exp + '.'
    end[0..-2]
  end

  private

  def clean
    @spec=Hash[@spec.delete_if {|_key,value| value==0}.sort]
  end
end
end