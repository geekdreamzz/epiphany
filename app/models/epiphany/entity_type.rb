module Epiphany
  class EntityType < ApplicationRecord
    include EntityTypes::Csv
    include OnSave

    has_many :entity_items
    has_one :analyzer
    has_one :voice_assistant

    before_save :normalize_name

    def add_items(phrases)
      phrases = phrases.split(',')
      items = []
      phrases.each do |phrase|
        phrase = phrase.strip&.downcase
        unless EntityItem.exists?(name: phrase, entity_type_id: self.id)
          items << entity_items.create(name: phrase)
        end
      end
      _items = items.blank? ? EntityItem.where(name: phrases[0].strip, entity_type_id: self.id) : items
      _items.first
    end

    def create_or_add_item_w(name, metadata)
      if item = EntityItem.where(name: name, entity_type_id: self.id).first
        item.update(metadata: metadata)
      else
        EntityItem.create(name: name, entity_type_id: self.id, metadata: metadata)
      end
    end

    class << self
      def create_with_key_phrases(voice_assistant, params)
        entity_type = create(name: params[:entity_type_name]&.strip, voice_assistant_id: voice_assistant.id)
        phrases = params[:key_phrases].split(',')
        phrases.each do |phrase|
          phrase = phrase.strip&.downcase
          # TODO account for diff variations + plural/singular
          # maybe after_save hook on a variations field, name would be the canonical reference
          entity_type.entity_items.create(name: phrase)
        end
      end
    end
  end
end
