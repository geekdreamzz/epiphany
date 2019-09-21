module Epiphany
  class EntityItem < ApplicationRecord
    extend EntityItems::Stubber

    belongs_to :entity_type

    attr_accessor :tokenized_entities

    def process_metadata(metadata)
      return unless metadata.present? && metadata.is_a?(String)
      _metadata = JSON.parse(metadata)
      valid = _metadata.map do |k,v|
        k.present? && v.present?
      end.all?
      self.update(metadata: metadata) if valid
    end

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
        where(name: str_tokens)
      end

      def match_ids(str_tokens)
        str_token_matches(str_tokens).pluck(:id)
      end
    end
  end
end
