module SubstitutionCipher
  def self.decode(key:, cipher_text:)
    cipher_text.chars.map { |c| key[c] || c }.join
  end
end

