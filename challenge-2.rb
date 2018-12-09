require_relative './cipher_cracker'

CipherCracker.decode_file(
  file_path: './ciphers/challenge-2.txt',
  word_hash: Language.latin_word_hash,
  type: :caesar)

