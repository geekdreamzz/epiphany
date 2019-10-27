module Epiphany
  module Tokenizer
    # included in voice_assistant.rb
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
        ::Epiphany::Tokenizer::Fragmenter.fragmenter(_string)
      end

    end
  end
end
