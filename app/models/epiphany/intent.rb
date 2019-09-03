module Epiphany
  class Intent < ApplicationRecord
    extend Intents::Generator
    include Intents::EditHelper
    include Intents::RulesHelper
    include Intents::CalculateScore

    attr_accessor :tokenized_entity_items, :score, :phrase

    class << self
      def calculate(voice_assistant, phrase)
        tokenized_entity_items = voice_assistant.tokenize(phrase.phrase)
        intents = intents_of(voice_assistant, tokenized_entity_items, phrase)
        _sorted = sorted(intents)
        top_intent(_sorted)
      end

      def intents_of(voice_assistants, tokenized_entity_items, phrase)
        voice_assistants.intents.map do |intent|
          intent.calculate_with(tokenized_entity_items, phrase)
        end
      end

      def sorted(intents)
        intents.sort_by do |intent|
          intent.score
        end.reverse
      end

      def top_intent(_sorted)
        _sorted.first
      end
    end

  end
end
