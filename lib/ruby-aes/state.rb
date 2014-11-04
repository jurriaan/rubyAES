module AES
  # A state consists of 4 words, operations like sbox or mix are applied to all words coordinate-wise
  class State
    include Comparable
    attr_accessor :words

    def initialize(*words)
      @words = words.flatten
    end

    def [](index)
      words[index]
    end

    def sbox!
      words.map!(&:sbox!)
      self
    end

    def mix!
      words.map!(&:mix!)
      self
    end

    def demix!
      words.map!(&:demix!)
      self
    end

    def inverse_sbox!
      words.map!(&:inverse_sbox!)
      self
    end

    # Shifts the rows (ρ)
    def shift_rows!
      row_shift
    end

    # Reverses shift_rows! (ρ^-1 = ρ^4)
    def unshift_rows!
      row_shift(-1) # Should be the same as row_shift(4)
    end

    # Used to blind the state (τ)
    def <<(other)
      4.times { |index| @words[index] << other[index] }
      self
    end

    # Blinds the state but returns a copy
    def +(other)
      State.new(4.times.map { |index| @words[index] + other[index] })
    end

    alias_method :-, :+

    def <=>(other)
      words <=> other.words
    end

    def inspect
      "<State: #{self}>"
    end

    def to_s
      words.to_s
    end

    private

    def row_shift(direction = 1)
      @words = 4.times.map do |i|
        Word.new(4.times.map { |byte| words[(i + direction * byte) % 4][byte] })
      end
      self
    end
  end
end
