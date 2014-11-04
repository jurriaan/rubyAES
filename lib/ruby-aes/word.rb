module AES
  # A word contains 4 bytes
  class Word
    include Comparable
    attr_accessor :bytes

    def initialize(*bytes)
      # Make sure the values are all valid bytes
      @bytes = bytes.flatten.map! { |byte| Byte.new(byte) }
    end

    def [](index)
      bytes[index]
    end

    def xi
      Word.new(bytes.clone).xi!
    end

    def xi!
      sbox! # Apply S-box to all elements
      bytes.rotate! # Rotate the bytes
      self
    end

    # Mix Columns / μ
    def mix!
      do_mix(0x02, 0x03, 0x01, 0x01)
    end

    # Inverse Mix Columns / ν
    def demix!
      do_mix(0x0E, 0x0B, 0x0D, 0x09)
    end

    def sbox!
      bytes.map!(&:sbox) # Apply S-box to all elements
      self
    end

    def inverse_sbox!
      bytes.map!(&:inverse_sbox)
      self
    end

    def <<(other)
      4.times { |index| bytes[index] += other[index] }
      self
    end

    def +(other)
      Word.new(4.times.map { |index| bytes[index] + other[index] })
    end

    alias_method :-, :+

    def <=>(other)
      bytes <=> other.bytes
    end

    def inspect
      "<Word: #{self}>"
    end

    def to_s
      bytes.to_s
    end

    def to_a
      bytes
    end

    private

    # Applies the μ/ν transformation
    def do_mix(*vector)
      @bytes = 4.times.each_with_object([]) do |i, newbytes|
        newbytes[i] = 4.times.reduce(0) do |a, index|
          bytes[index] * vector[(index - i) % 4] + a
        end
      end
      self
    end
  end
end
