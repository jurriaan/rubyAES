module AES
  class Key < State
    def [](index)
      key[index]
    end

    def encrypt(state)
      state += expanded_key(0)
      1.upto(9) do |index|
        state.sbox!
        state.shift_rows!
        state.mix!
        state << expanded_key(index)
      end
      state.sbox!
      state.shift_rows!
      state << expanded_key(10)
    end

    def decrypt(state)
      state += expanded_key(10)
      state.unshift_rows!
      state.inverse_sbox!
      9.downto(1) do |index|
        state << expanded_key(index)
        state.demix!
        state.unshift_rows!
        state.inverse_sbox!
      end
      state << expanded_key(0)
    end

    def inspect
      "<Key: #{self}>"
    end

    private

    def expanded_key(index)
      4.times.map { |i| key[index * 4 + i] }
    end

    # Dynamically derive the words using the Rijndael key schedule
    # Use a memoized Hash for storage
    def key
      @key ||= Hash.new do |hash, j|
        hash[j] = hash[j - 4] +
          if j % 4 == 0
            hash[j - 1].xi + Word.new(Byte.new(2) ** ((j / 4) - 1), 0, 0, 0)
          else
            hash[j - 1]
          end
      end.tap do |hash| # initializes key[0..3]
        @words.each_with_index do |word, index|
          hash[index] = word
        end
      end
    end
  end
end
