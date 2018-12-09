module Language
  def self.english_word_hash
    @english ||= word_hash_from_file(file_path: '/data/english-words.txt')
  end

  def self.latin_word_hash
    @@latin ||= word_hash_from_file(file_path: '../data/latin-words.txt')
  end

  def self.word_hash_from_file(file_path:)
    word_dict = Hash.new

    File.open(file_path) do |file|
      file.each_line do |line|
        word_dict[line.strip] = true
      end
    end

    word_dict
  end

  def self.word_string_from_word_hash(word_hash:)
    @word_strings ||= {}

    if @word_strings.has_key?(word_hash.object_id)
      @word_strings[word_hash.object_id]
    else
      @word_strings[word_hash.object_id] = word_hash.keys.join("\n")
    end
  end

  def self.match_word?(regex:, word_hash:)
    word_string_from_word_hash(word_hash: word_hash).match(regex) != nil
  end

  def self.number_of_matching_words(text:, word_hash:)
    text.split(' ').count { |word| is_word?(word: word, word_hash: word_hash) }
  end

  def self.split_into_words(text:)
    text.split(/[^\w']+/)
  end

  def self.is_word?(word:, word_hash:)
    word_hash.has_key?(word)
  end
end

