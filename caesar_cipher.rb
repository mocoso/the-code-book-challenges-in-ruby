require_relative './substitution_cipher'

module CaesarCipher
  def self.decode(key:, cipher_text:)
    SubstitutionCipher.decode(
      key: substitution_cipher_key(key),
      cipher_text: cipher_text)
  end

  def self.substitution_cipher_key(key)
    @substitution_ciphers ||= {}

    if @substitution_ciphers.has_key?(key)
      @substitution_ciphers[key]
    else
      @substitution_ciphers[key] = ('A'..'Z').to_a.zip(('a'..'z').to_a.rotate(-key)).to_h
    end
  end
end

