require_relative './cipher_cracker'
require_relative './substitution_cipher'

CipherCracker.new(SubstitutionCipher).
  decode_file('./ciphers/challenge-1.txt')

