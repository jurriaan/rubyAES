require_relative '../../test_helper'

describe AES::Byte do
  it 'should multiply correctly' do
    (AES::Byte.new(2) * AES::Byte.new(20)).must_equal AES::Byte.new(40)
    (AES::Byte.new(2) * AES::Byte.new(32)).must_equal AES::Byte.new(64)
    (AES::Byte.new(2) * AES::Byte.new(0x80)).must_equal AES::Byte.new(0x1B)
  end

  it 'should be devisable' do
    (AES::Byte.new(32) / AES::Byte.new(32)).must_equal AES::Byte.new(1)
    (AES::Byte.new(32) / AES::Byte.new(2)).must_equal AES::Byte.new(16)
    (AES::Byte.new(0x1B) / AES::Byte.new(2)).must_equal AES::Byte.new(0x80)
  end
end
