module Epiphany
  module Tokenizer
    module Base
      def tokenize(phrase)
        @phrase = phrase
        analyze(str_tokens)
      end

      def phrase
        @phrase ||= ''
      end

      def str_tokens
        fragmenter(phrase)
      end

      def fragmenter(_string)
        fragments = _string.split(' ')
        end_idx = fragments.length
        (0..end_idx).map do |idx|
          (idx..end_idx).map do |idx2|
            fragments[idx..idx2].join(' ')&.downcase&.presence
          end
        end.flatten.uniq.compact #TODO def. optimize this later
      end

    end
  end
end
