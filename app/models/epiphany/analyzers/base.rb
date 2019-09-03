module Epiphany
  module Analyzers
    module Base
      include Number
      include AdvancedAnalysis

      def analyze(str_tokens)
        @str_tokens = str_tokens
        tokens = str_tokens.map do |str_token|
          matches = []

          # sys detections
          matches << create_number(str_token) if create_number?(str_token)

          # we break each token down again for advanced analysis
          # it's kinda confusing but this is where the magic kinda happens
          # for advanced analysis, breaking it down again allows us to determine
          # where each entity within a token really is
          # it may be inefficient in terms of iterations so we can investigate optimizing this
          # but it's very accurate and that's what we are focused on for now
          _str_tokens = fragmenter(str_token)
          matches << matches(_str_tokens)
          advanced_analysis(str_token, matches.flatten)
        end

        tokens.flatten.uniq
      end

      def matches(str_tokens)
        ::Epiphany::EntityItem.str_token_matches(str_tokens)
      end

    end
  end
end
