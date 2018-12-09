require_relative './language'
require_relative './caesar_cipher'
require_relative './substitution_cipher'

require 'fibonacci_heap'

module CipherCracker
  def self.decode_file(file_path:, word_hash:, type:)
    decode(cipher_text: File.read(file_path), word_hash: word_hash, type: type)
  end

  def self.decode(cipher_text:, word_hash:, type:)
    case type
    when :substitution
       key = substitution_cipher_key_finder(cipher_text: cipher_text, word_hash: word_hash)
       plain_text = SubstitutionCipher.decode(key: key, cipher_text: cipher_text)
    when :caesar
       key = caesar_cipher_key_finder(cipher_text: cipher_text, word_hash: word_hash)
       plain_text = CaesarCipher.decode(key: key, cipher_text: cipher_text)
    else
      raise 'Unrecognised type'
    end

    puts "\n\nDecoded:\n" + plain_text
    puts "\nNumber of words matched: " + Language.number_of_matching_words(text: plain_text, word_hash: word_hash).to_s
  end

  def self.substitution_cipher_key_finder(cipher_text:, word_hash:)
    partial_keys_heap = FibonacciHeap::Heap.new
    partial_keys_heap.insert(FibonacciHeap::Node.new(0, {}))
    keys_heap = FibonacciHeap::Heap.new
    iteration = 0

    while keys_heap.size <= 1000
      iteration += 1

      partial_key_node = partial_keys_heap.pop
      partial_key = partial_key_node.value

      letter = next_coded_letter_to_decipher(partial_key: partial_key, cipher_text: cipher_text)
      if letter
        generate_possible_next_keys(partial_key: partial_key, next_coded_letter: letter).each do |key|
          node = FibonacciHeap::Node.new(
            -partial_key_score(partial_key: key, cipher_text: cipher_text, word_hash: word_hash),
            key
          )

          partial_keys_heap.insert(node)
        end
      else
        keys_heap.insert(partial_key_node)
      end

      if (iteration % 10) == 0
        partial_decipher = SubstitutionCipher.decode(key: partial_key, cipher_text: cipher_text)
        puts "Current best decoding: " + partial_decipher
      end
    end

    keys_heap.pop.value
  end

  def self.caesar_cipher_key_finder(cipher_text:, word_hash:)
    (1..25).to_a.max do |key|
      Language.number_of_matching_words(
        text: CaesarCipher.decode(key: key, cipher_text: cipher_text),
        word_hash: word_hash)
    end
  end

  def self.coded_letters_in_freqency_order(cipher_text:)
    @coded_letters_in_freqency_orders ||= {}

    if @coded_letters_in_freqency_orders.has_key?(cipher_text)
      @coded_letters_in_freqency_orders[cipher_text]
    else
      letter_counts = Hash.new(0)
      cipher_text.gsub(/[^A-Z]+/, '').
        chars.map { |l| letter_counts[l] +=1 }

      @coded_letters_in_freqency_orders[cipher_text] = letter_counts.
        to_a.sort_by { |p| -p.last }.
        map { |p| p.first }
    end
  end

  def self.next_coded_letter_to_decipher(partial_key:, cipher_text:)
    remaining_coded_letters =
      coded_letters_in_freqency_order(cipher_text: cipher_text) - partial_key.keys

    if remaining_coded_letters.size > 0
      remaining_coded_letters.first
    else
      nil
    end
  end

  def self.partial_key_score(partial_key:, cipher_text:, word_hash:)
    partial_decipher = SubstitutionCipher.decode(key: partial_key, cipher_text: cipher_text)

    word_blocks = Language.split_into_words(text: partial_decipher)

    score = word_blocks.sum { |word_block|
      if text_is_fully_ciphered?(text: word_block)
        1
      elsif text_is_fully_deciphered?(text: word_block)
        if Language.is_word?(word: word_block, word_hash: word_hash)
          4
        else
          0
        end
      else
        regex = matcher_for_partially_deciphered_word(partial_key: partial_key, word: word_block)
        Language.match_word?(regex: regex, word_hash: word_hash) ? 1 : 0
      end
    }

    score
  end

  def self.matcher_for_partially_deciphered_word(partial_key:, word:)
     code_match_regex_part = "[^#{partial_key.values.join()}]"
     Regexp.new "^#{word.gsub(/[^a-z]/, code_match_regex_part)}$"
  end

  def self.text_is_fully_ciphered?(text:)
    text.match(/^[^a-z]+$/)
  end

  def self.text_is_fully_deciphered?(text:)
    text.match(/^[a-z]+$/)
  end

  def self.generate_possible_next_keys(partial_key:, next_coded_letter:)
    (('a'..'z').to_a - partial_key.values).map { |letter|
      new_key = partial_key.clone
      new_key[next_coded_letter] = letter
      new_key
    }
  end
end

