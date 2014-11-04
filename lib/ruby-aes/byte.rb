module AES
  class Byte
    include Comparable
    attr_accessor :value

    def initialize(value)
      @value = value.to_i & 0xFF # Force byte to be a byte
    end

    # Perform exponentation
    def **(exponent)
      Byte.new(Tables.alog[(log * exponent) % 0xFF])
    end

    # Perform a multiplication using the log table
    def *(other)
      other = Byte.new(other)
      return Byte.new(0) if value == 0 || other.value == 0
      Byte.new(Tables.alog[(log + other.log) % 0xFF])
    end

    # Perform devision by multiplying by the inverse
    def /(other)
      self * other.inverse
    end

    # Addition is the same as XORing the values
    def +(other)
      other = Byte.new(other)
      Byte.new(to_i ^ other.to_i)
    end

    # Addition is the same as subtraction
    alias_method :-, :+

    alias_method :^, :+

    def sbox
      Byte.new(Tables.sbox[value])
    end

    def inverse_sbox
      Byte.new(Tables.inverse_sbox[value])
    end

    def inverse
      Byte.new(Tables.inverse[value])
    end

    # The log method returns a Fixnum, since it's value is not in the Rijndael
    # field
    def log
      Tables.log[value]
    end

    def <=>(other)
      value <=> other.value
    end

    def inspect
      "<Byte: 0x#{value.to_s(16).upcase}>"
    end

    def to_s
      value.to_s
    end

    def to_i
      value
    end
  end
end
