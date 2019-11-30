module Epiphany
  class VoiceAssistant < ApplicationRecord
    EXPORT_DIR = Etl::Export::EXPORT_DIR

    include Tokenizer::Base
    include Analyzers::Base
    include Etl::Export
    extend  Etl::Import

    has_many :entity_types
    has_many :entity_items, through: :entity_types
    has_many :analyzers
    has_many :intents
    has_many :training_phrases

    def calculate_intent_of(phrase_text)
      phrase_model = training_phrases.find_or_create_by(phrase: phrase_text)
      ::Epiphany::Intent.calculate(self, phrase_model)
    end

    def unknown_intent(tokenized_entity_items, phrase)
      intents.new(name: 'intent unknown').set_props(tokenized_entity_items, phrase)
    end

    def create_entity_type(params)
      EntityType.create_with_key_phrases(self, params)
    end

    def create_or_update_intent(params)
      Intent.create_from(self, params)
    end

    def create_or_update_advanced_analyzer(params)
      Analyzer.create_from(self, params)
    end

    def save_training_phrase(params)
      TrainingPhrase.create_or_update_from(self, params)
    end

    def all_entity_types
      ::Epiphany::EntityType.where(voice_assistant_id: [id, 0]) # gets sys entity types + voice assistant entity types
    end
  end
end
