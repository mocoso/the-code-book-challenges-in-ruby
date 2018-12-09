require_relative '../cipher_cracker'
require_relative '../substitution_cipher'

describe CipherCracker do
  subject { CipherCracker.new(SubstitutionCipher) }

  describe 'partial_key_score' do
    let(:partial_key) { { 'A' => 'd', 'B' => 'o', 'C' => 'g' } }

    specify 'all words are deciphered and match english words' do
      expect(subject.partial_key_score(partial_key, 'ABC CBA')).
        to eq(8)
    end

    specify '2 words are deciphered and 2 could match english words' do
      expect(subject.partial_key_score(partial_key, 'ABC XYZ CXZ CBA')).
        to eq(10)
    end

    specify '2 words are deciphered words and 1 could match an english  word and the other not' do
      expect(subject.partial_key_score(partial_key, 'ABC XYZ CCZ CBA')).
        to eq(9)
    end

    specify 'all words are deciphered and none are english words' do
      expect(subject.partial_key_score(partial_key, 'ACB CAB')).
        to eq(0)
    end
  end
end

