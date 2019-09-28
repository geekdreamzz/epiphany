module Epiphany
  class Intent < ApplicationRecord
    extend Intents::Generator
    include Intents::EditHelper
    include Intents::RulesHelper
    include Intents::CalculateScore
    include Analyzers::PartsOfSpeech
    include OnSave

    before_save :normalize_name

    # bad at naming stuff and I couldn't decide - sorry!
    alias_attribute :metadata, :rules
    attr_accessor :tokenized_entity_items, :score, :phrase

    def constant_name
      name.split(' ').map(&:capitalize).join
    end

    def unknown?
      name == 'intent unknown'
    end

    class << self
      def calculate(voice_assistant, phrase)
        tokenized_entity_items = voice_assistant.tokenize(phrase.phrase)
        intents = intents_of(voice_assistant, tokenized_entity_items, phrase)
        _sorted = sorted(intents)
        top_intent(_sorted, tokenized_entity_items, phrase, voice_assistant)
      end

      def intents_of(voice_assistants, tokenized_entity_items, phrase)
        voice_assistants.intents.map do |intent|
          intent.calculate_with(tokenized_entity_items, phrase)
        end.compact
      end

      def sorted(intents)
        intents.sort_by do |intent|
          intent.score
        end.reverse
      end

      def top_intent(_sorted, tokenized_entity_items, phrase, voice_assistant)
        _sorted.first || voice_assistant.unknown_intent(tokenized_entity_items, phrase)
      end
    end

  end
end
