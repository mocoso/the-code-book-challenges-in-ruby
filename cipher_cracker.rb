require_relative './language'
require 'fibonacci_heap'

class CipherCracker
  attr_reader :cipher_class

  def initialize(cipher_class)
    @cipher_class = cipher_class
  end

  def decode_file(filename)
    decode(File.read(filename))
  end

  def decode(cipher_text)
    simplified_cipher_text = Language.english.split_into_words(cipher_text).uniq.join(' ')

    partial_keys_heap = FibonacciHeap::Heap.new
    partial_keys_heap.insert(FibonacciHeap::Node.new(0, {}))
    keys_heap = FibonacciHeap::Heap.new
    iteration = 0

    while keys_heap.size <= 1000
      iteration += 1

      partial_key_node = partial_keys_heap.pop
      partial_key = partial_key_node.value

      letter = next_coded_letter_to_decipher(partial_key, simplified_cipher_text)
      if letter
        cipher_class.new(partial_key).generate_possible_next_keys(letter).each do |key|
          node = FibonacciHeap::Node.new(
            -partial_key_score(key, simplified_cipher_text),
            key
          )

          partial_keys_heap.insert(node)
        end
      else
        keys_heap.insert(partial_key_node)
      end

      if (iteration % 10) == 0
        partial_decipher = cipher_class.new(partial_key).decode(cipher_text)
        puts "Current best decoding: " + partial_decipher
      end
    end

    best_key_node = keys_heap.pop
    plain_text = cipher_class.new(best_key_node.value).decode(cipher_text)

    puts "\n\nDecoded:\n" + plain_text
    puts "\nNumber of words matched: " + Language.english.number_of_english_words(plain_text).to_s
  end

  def next_coded_letter_to_decipher(partial_key, cipher_text)
    partial_decipher = cipher_class.new(partial_key).decode(cipher_text)
    remaining_coded_letters = partial_decipher.gsub(/[^A-Z]+/, '')

    if remaining_coded_letters.size > 0
      remaining_coded_letters.chars.first
    else
      nil
    end
  end

  def partial_key_score(partial_key, cipher_text)
    partial_decipher = cipher_class.new(partial_key).
      decode(cipher_text)

    word_blocks = Language.english.split_into_words(partial_decipher)
    code_match_regex_part = "[^#{partial_key.values.join()}]"

    score = word_blocks.sum { |word_block|
      if word_block.match(/^[^a-z]+$/)
        1
      elsif word_block.match(/^[a-z]+$/)
        if Language.english.is_word?(word_block)
          4
        else
          0
        end
      else
        word_block_matcher = Regexp.new "^#{word_block.gsub(/[^a-z]/, code_match_regex_part)}$"
        Language.english.match_word?(word_block_matcher) ? 1 : 0
      end
    }

    score
  end
end

