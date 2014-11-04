require_relative '../../test_helper'

describe AES::Key do
  it 'should correctly generate the key' do
    w1 = AES::Word.new(0x01, 0x02, 0x03, 0x04)
    w2 = AES::Word.new(0x05, 0x06, 0x07, 0x08)
    w3 = AES::Word.new(0x09, 0x0A, 0x0B, 0x0C)
    w4 = AES::Word.new(0x0D, 0x0E, 0x0F, 0x10)
    key = AES::Key.new(w1, w2, w3, w4)
    key[0].must_equal(w1)
    key[1].must_equal(w2)
    key[2].must_equal(w3)
    key[3].must_equal(w4)
    key[10].must_equal(AES::Word.new(0x98, 0x0A, 0x04, 0x73))
  end

  it 'should correctly expand keys' do
    # source: http://www.samiam.org/key-schedule.html
    Dir[File.expand_path('keys/expansion*.txt', $SUPPORT_DIR)].each do |file|
      words = AES::Util.hex_to_words(open(file).read)
      key = AES::Key.new(words[0..3])
      words.each_with_index do |word, index|
        key[index].must_equal(word)
      end
    end
  end

  it 'should encrypt correctly' do
    key = AES::Key.new(AES::Word.new(0x0f, 0x15, 0x71, 0xc9),
                       AES::Word.new(0x47, 0xd9, 0xe8, 0x59),
                       AES::Word.new(0x0c, 0xb7, 0xad, 0xd6),
                       AES::Word.new(0xaf, 0x7f, 0x67, 0x98))
    message = AES::State.new(AES::Word.new(0, 0, 0, 0),
                             AES::Word.new(0, 0, 0, 0),
                             AES::Word.new(0, 0, 0, 0),
                             AES::Word.new(0, 0, 0, 0))
    encrypted_message = AES::State.new(AES::Word.new(0x0a, 0x40, 0x26, 0xdc),
                                       AES::Word.new(0xcc, 0x7b, 0x4f, 0x51),
                                       AES::Word.new(0xbb, 0x34, 0x11, 0x3a),
                                       AES::Word.new(0xc3, 0x83, 0xca, 0xf1))
    key.encrypt(message).must_equal(encrypted_message)
  end

  it 'should decrypt correctly' do
    key = AES::Key.new(AES::Word.new(0x0f, 0x15, 0x71, 0xc9),
                       AES::Word.new(0x47, 0xd9, 0xe8, 0x59),
                       AES::Word.new(0x0c, 0xb7, 0xad, 0xd6),
                       AES::Word.new(0xaf, 0x7f, 0x67, 0x98))
    message = AES::State.new(AES::Word.new(0, 0, 0, 0),
                             AES::Word.new(0, 0, 0, 0),
                             AES::Word.new(0, 0, 0, 0),
                             AES::Word.new(0, 0, 0, 0))
    encrypted_message = AES::State.new(AES::Word.new(0x0a, 0x40, 0x26, 0xdc),
                                       AES::Word.new(0xcc, 0x7b, 0x4f, 0x51),
                                       AES::Word.new(0xbb, 0x34, 0x11, 0x3a),
                                       AES::Word.new(0xc3, 0x83, 0xca, 0xf1))
    key.decrypt(encrypted_message).must_equal(message)
  end

  it 'should reversibly encrypt' do
    # source: http://csrc.nist.gov/publications/nistpubs/800-38a/sp800-38a.pdf
    key = AES::Key.new(AES::Util.hex_to_words('2b7e151628aed2a6abf7158809cf4f3c'))
    data = {
      '6bc1bee22e409f96e93d7e117393172a' => '3ad77bb40d7a3660a89ecaf32466ef97',
      'ae2d8a571e03ac9c9eb76fac45af8e51' => 'f5d3d58503b9699de785895a96fdbaaf',
      '30c81c46a35ce411e5fbc1191a0a52ef' => '43b1cd7f598ece23881b00e3ed030688',
      'f69f2445df4f9b17ad2b417be66c3710' => '7b0c785e27e8ad3f8223207104725dd4'
    }
    data.each do |message, encrypted_message|
      message = AES::State.new(AES::Util.hex_to_words(message))
      encrypted_message = AES::State.new(AES::Util.hex_to_words(encrypted_message))
      key.encrypt(message).must_equal(encrypted_message)
      key.decrypt(encrypted_message).must_equal(message)
    end
  end

end
