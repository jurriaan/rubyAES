require_relative '../../test_helper'

describe AES::Word do
  it 'should xi correctly' do
    w = AES::Word.new(0x12, 0x24, 0x48, 0x81)
    xi_w = AES::Word.new(0x36, 0x52, 0xC, 0xC9)
    w.xi.must_equal(xi_w)
  end

  it 'should mix correctly' do
    w = AES::Word.new(0x12, 0x24, 0x48, 0x81)
    mu_w = AES::Word.new(0x81, 0x3, 0x3E, 0x43)
    w.mix!.must_equal(mu_w)
  end

  it 'should demix correctly' do
    mu_w = AES::Word.new(0x81, 0x3, 0x3E, 0x43)
    w = AES::Word.new(0x12, 0x24, 0x48, 0x81)

    mu_w.demix!.must_equal(w)
  end

  it 'should be reversible' do
    w = AES::Word.new([0xC3, 0x76, 0xD8, 0x78])
    w2 = w.clone
    w2.mix!.demix!
    w.must_equal(w2)
  end

  it 'should be mathematically correct' do
    mu = AES::Word.new(0x81, 0x3, 0x3E, 0x43)

    mu.demix!.must_equal(mu.mix!.mix!)
  end
end
