module Epiphany
  class TrainingPhrase < ApplicationRecord
    include ::Epiphany::Tokenizer

    belongs_to :voice_assistant

    def detected_entities

    end

    class << self
      def create_or_update_from(voice_assistant, params)
        # in the future support additional props for update?
        phrase = params[:training_phrase].downcase
        return if voice_assistant.training_phrases.exists?(phrase: phrase)
        voice_assistant.training_phrases.create(phrase: phrase)
      end
    end
  end
end
