require_relative '../../test_helper'

describe AES::State do
  it 'should be mathematically correct' do
    w1 = AES::Word.new(0x01, 0x02, 0x03, 0x04)
    w2 = AES::Word.new(0x05, 0x06, 0x07, 0x08)
    w3 = AES::Word.new(0x09, 0x0A, 0x0B, 0x0C)
    w4 = AES::Word.new(0x0D, 0x0E, 0x0F, 0x10)
    start_state = AES::State.new(w1, w2, w3, w4)
    state = start_state.clone
    state.shift_rows!
    state.wont_equal(start_state)
    state.shift_rows!
    state.shift_rows!
    state.shift_rows!
    state.must_equal(start_state)
  end

  it 'should be possible to unshift a shifted state' do
    w1 = AES::Word.new(0x01, 0x02, 0x03, 0x04)
    w2 = AES::Word.new(0x05, 0x06, 0x07, 0x08)
    w3 = AES::Word.new(0x09, 0x0A, 0x0B, 0x0C)
    w4 = AES::Word.new(0x0D, 0x0E, 0x0F, 0x10)
    start_state = AES::State.new(w1, w2, w3, w4)
    state = start_state.clone
    state.shift_rows!
    state.wont_equal(start_state)
    state.unshift_rows!
    state.must_equal(start_state)
  end
end
