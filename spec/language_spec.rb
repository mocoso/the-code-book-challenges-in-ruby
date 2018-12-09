require_relative '../language'

describe Language do
  describe 'english' do
    let(:word_hash) { Language.english_word_hash }

    describe 'number_of_matching_words' do
      specify { expect(subject.number_of_matching_words(text: 'dog god dgo', word_hash: word_hash)).
        to eq(2)
      }
    end

    describe 'split_into_words' do
      specify {
        expect(subject.split_into_words(text: "The lazy dog, can't be THerE")).
          to eq(['The', 'lazy', 'dog', "can't", 'be', 'THerE'])
        }
    end

    describe 'is_word?' do
      specify { expect(subject.is_word?(word: 'dog', word_hash: word_hash)).to eq(true) }
      specify { expect(subject.is_word?(word: 'dgo', word_hash: word_hash)).to eq(false) }
    end

    describe 'match_word?' do
      specify {
        expect(subject.match_word?(regex: /^a[^a][^a]$/, word_hash: word_hash)).
          to eq(true)
      }

      specify {
        expect(subject.match_word?(regex: /^qq[^q]$/, word_hash: word_hash)).
          to eq(false)
      }
    end
  end
end
