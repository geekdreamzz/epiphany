module Epiphany
  class EntityItem < ApplicationRecord
    extend EntityItems::Stubber
    include EntityItems::VariationsSave
    include OnSave

    belongs_to :entity_type
    attr_accessor :tokenized_entities
    before_save :normalize_name
    before_save :default_variations

    def serialized_metadata
      return {} unless metadata.present?
      JSON.parse(metadata)
    end

    def voice_assistant
      @voice_assistant ||= ::Epiphany::VoiceAssistant.find(entity_type.voice_assistant_id)
    end

    def tokenize
      @tokenized_entities ||= voice_assistant.tokenize(name)
    end

    class << self

      def matches(ids)
        where(id: ids)
      end

      #fragments is an array of strings. Tokenized from original phrase
      def str_token_matches(str_tokens)
        where("variations && ARRAY[?]", str_tokens).sort_by { |item| item.name.length  }.reverse
      end

      def match_ids(str_tokens)
        str_token_matches(str_tokens).pluck(:id)
      end
    end
  end
end
