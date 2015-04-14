# encoding: utf-8

module Pulo
  def super_digit(val)
    val.to_s.chars.inject('') do |res, chr|
      res+= case chr
              when '.'
                "\u207B".encode('utf-8')
              when '-'
                "\u207B".encode('utf-8')
              when '1'
                "\u00B9".encode('utf-8')
              when '2'
                "\u00B2".encode('utf-8')
              when '3'
                "\u00B3".encode('utf-8')
              when '0'
                "\u2070".encode('utf-8')
              when '4'
                "\u2074".encode('utf-8')
              when '5'
                "\u2075".encode('utf-8')
              when '6'
                "\u2076".encode('utf-8')
              when '7'
                "\u2077".encode('utf-8')
              when '8'
                "\u2078".encode('utf-8')
              when '9'
                "\u2079".encode('utf-8')
              else
                ''
            end
    end
  end

  class NumberToRoundedConverter
    def self.convert(number, precision)

      precision ||= Pulo.precision

      case number
        when Float, String
          @number = BigDecimal(number.to_s)
        when Rational
          @number = BigDecimal(number, digit_count(number.to_i) + precision)
        else
          @number = number.to_d
      end

      if Pulo.significant_figures && precision > 0
        digits, rounded_number = digits_and_rounded_number(number, precision)
        precision -= digits
        precision = 0 if precision < 0 # don't let it be negative
      else
        rounded_number = number.round(precision)
        rounded_number = rounded_number.to_i if precision == 0
        rounded_number = rounded_number.abs if rounded_number.zero? # prevent showing negative zeros
      end
      formatted_string =
          if BigDecimal === rounded_number && rounded_number.finite?
            s = rounded_number.to_s('F') + '0'*precision
            a, b = s.split('.', 2)
            a + '.' + b[0, precision]
          else
            "%00.#{precision}f" % rounded_number
          end

      delimited_number = NumberToDelimitedConverter.convert(formatted_string)
      format_number(delimited_number)
    end

    private

    def self.digits_and_rounded_number(number,precision)
      if zero?(number)
        [1, 0]
      else
        digits = digit_count(number)
        multiplier = 10 ** (digits - precision)
        rounded_number = calculate_rounded_number(number,multiplier)
        digits = digit_count(rounded_number) # After rounding, the number of digits may have changed
        [digits, rounded_number]
      end
    end

    def self.calculate_rounded_number(number,multiplier)
      (number / BigDecimal.new(multiplier.to_f.to_s)).round * multiplier
    end

    def self.digit_count(number)
      number.zero? ? 1 : (Math.log10(absolute_number(number)) + 1).floor
    end

    def self.format_number(number)
      escaped_separator = Regexp.escape('.')
      number.sub(/(#{escaped_separator})(\d*[1-9])?0+\z/, '\1\2').sub(/#{escaped_separator}\z/, '')
    end

    def self.absolute_number(number)
      number.respond_to?(:abs) ? number.abs : number.to_d.abs
    end

    def self.zero?(number)
      number.respond_to?(:zero?) ? number.zero? : number.to_d.zero?
    end
  end

  class NumberToDelimitedConverter
    DELIMITED_REGEX = /(\d)(?=(\d\d\d)+(?!\d))/

    def self.convert(number)
      parts(number).join('.')
    end

    private

    def self.parts(number)
      left, right = number.to_s.split('.')
      left.gsub!(DELIMITED_REGEX) do |digit_to_delimit|
        "#{digit_to_delimit},"
      end
      [left, right].compact
    end
  end

end

class BigDecimal
  DEFAULT_STRING_FORMAT = 'F'
  def to_formatted_s(*args)
    if args[0].is_a?(Symbol)
      super
    else
      format = args[0] || DEFAULT_STRING_FORMAT
      _original_to_s(format)
    end
  end
  alias_method :_original_to_s, :to_s
  alias_method :to_s, :to_formatted_s
end