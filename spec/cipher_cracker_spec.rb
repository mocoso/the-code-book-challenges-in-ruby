require_relative '../cipher_cracker'
require_relative '../substitution_cipher'

describe CipherCracker do
  let(:partial_key) { { 'A' => 'd', 'B' => 'o', 'C' => 'g' } }

  describe 'partial_key_score' do
    let(:word_hash) { { 'dog' => true, 'god' => true, 'gut' => true, 'cab' => true, 'gob' => true  } }

    specify 'word is a dictionary word' do
      expect(subject.partial_key_score(partial_key: partial_key, cipher_text: 'ABC', word_hash: word_hash)).
        to eq(1)
    end

    specify 'word is not a dictionary word' do
      expect(subject.partial_key_score(partial_key: partial_key, cipher_text: 'ACB', word_hash: word_hash)).
        to eq(-1)
    end

    specify 'word is partially deciphered and could match a dictionary word' do
      expect(subject.partial_key_score(partial_key: partial_key, cipher_text: 'CBZ', word_hash: word_hash)).
        to eq(0)
    end

    specify 'word is partically deciphered and could not match adictionary word' do
      expect(subject.partial_key_score(partial_key: partial_key, cipher_text: 'AAZ', word_hash: word_hash)).
        to eq(-1)
    end

    specify 'word is not deciphered at all' do
      expect(subject.partial_key_score(partial_key: partial_key, cipher_text: 'XYZ', word_hash: word_hash)).
        to eq(0)
    end
  end

  describe 'coded_letters_in_freqency_order' do
    specify 'most frequent letters first' do
      expect(subject.coded_letters_in_freqency_order(cipher_text: 'BCB CABBAAAAF')).
        to eq(%w(A B C F))
    end
  end

  describe 'next_coded_letter_to_decipher' do
    specify 'all already deciphered' do
      expect(subject.next_coded_letter_to_decipher(partial_key: partial_key, cipher_text: 'AABCA')).
        to be_nil
    end

    specify 'more letters to decipher' do
      expect(subject.next_coded_letter_to_decipher(partial_key: partial_key, cipher_text: 'AABWD')).
        to eq('W')
    end
  end

  describe 'generate_possible_next_keys' do
    specify 'when 3 letters are already in the partial key' do
      expect(subject.generate_possible_next_keys(partial_key: partial_key, next_coded_letter:'D').size).
        to eq(23)
    end
  end
end

