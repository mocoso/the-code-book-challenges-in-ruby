require_relative './cipher_cracker'
require_relative './substitution_cipher'

CipherCracker.decode_file(
  file_path: './ciphers/challenge-1.txt',
  word_hash: Language.english_word_hash)

