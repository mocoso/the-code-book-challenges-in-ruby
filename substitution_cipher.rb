module SubstitutionCipher
  def self.decode(key:, cipher_text:)
    cipher_text.chars.map { |c| key[c] || c }.join
  end

  def generate_possible_next_keys(next_coded_letter)
    (('a'..'z').to_a - key.values).map { |letter|
      new_key = key.clone
      new_key[next_coded_letter] = letter
      new_key
    }
  end
end

