module AES
  # This Module computes and holds the tables used by the various computations
  # in the Rijndael Galois field.
  module Tables
    extend self
    attr_accessor :log, :alog, :inverse, :sbox, :inverse_sbox

    REDUCING_POLYNOMIAL = 0x11B # m = x^8 + x^4 + x^3 + x^1 + 1
    G = 0x63 # g = x^6 + x^5 + x + 1

    def init
      @log = []
      @alog = []
      @inverse = []
      @sbox = []
      @inverse_sbox = []
      generate_logs
      generate_inverse
      generate_sboxes
    end

    private

    # Generate log and antilog tables using 3 as a generator
    # multiplying by three is the same as multiplying by two and adding the original value
    def generate_logs
      value = 1 # Start with the 0th power
      256.times do |log| # For all exponents 0-255
        @alog[log] = value
        @log[@alog[log]] = log

        value <<= 1 # Multiply by x
        value ^= REDUCING_POLYNOMIAL if value > 0xFF # If the value overflows
        value ^= @alog[log] # Add it's original value to itself
      end

      # Set some sensible defaults as log is only valid from 1-255
      # and antilog only from 0-254
      @log[0] = 0
      @alog[255] = @alog[0]
    end

    # Generate inverse table by making use of the logarithm tables
    def generate_inverse
      @inverse << 0
      1.upto(255) do |byte|
        @inverse[byte] = alog[log[1] - log[byte]] # compute 1/byte
      end
    end

    # Generate the sbox tables
    def generate_sboxes
      256.times do |byte|
        s = x = inverse[byte] # This works even for 0 since inverse[0] = 0
        4.times do
          s = ((s << 1) | (s >> 7)) & 0xFF # Rotate byte (s = s * x)
          x ^= s # x = x + s
        end
        @sbox[byte] = x ^ G # τ_g
        @inverse_sbox[@sbox[byte]] = byte
      end
    end
  end
  Tables.init
end
