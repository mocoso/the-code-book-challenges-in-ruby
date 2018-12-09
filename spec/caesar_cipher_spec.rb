require_relative '../caesar_cipher'

describe CaesarCipher do
  describe 'decode' do
    specify { expect(subject.decode(key: 2, cipher_text: 'FQI')).to eq('dog') }
  end
end

