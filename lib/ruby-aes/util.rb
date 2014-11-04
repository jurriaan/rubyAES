module AES
  module Util
    module_function

    def hex_to_words(hex)
      hex.scan(/(\w{2})\s*(\w{2})\s*(\w{2})\s*(\w{2})/).map do |word|
        AES::Word.new(word.map { |byte| byte.to_i(16) })
      end
    end
  end
end
