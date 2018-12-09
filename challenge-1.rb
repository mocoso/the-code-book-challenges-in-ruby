require_relative './cipher_cracker'

CipherCracker.decode_file(
  file_path: './ciphers/challenge-1.txt',
  word_hash: Language.english_word_hash,
  type: :substitution)

