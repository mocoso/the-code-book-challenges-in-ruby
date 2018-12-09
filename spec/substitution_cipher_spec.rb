require_relative '../substitution_cipher'

describe SubstitutionCipher do
  describe 'decode' do
    let(:key) { { 'A' => 'd', 'B' => 'o', 'C' => 'g' } }

    specify { expect(subject.decode(key: key, cipher_text: 'ABC')).to eq('dog') }
    specify { expect(subject.decode(key: key, cipher_text: 'ABC CBA')).to eq('dog god') }
  end
end
