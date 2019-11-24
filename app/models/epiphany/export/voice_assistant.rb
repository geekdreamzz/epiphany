module Epiphany
  module Export
    module VoiceAssistant
      def export_to_json(directory)
        File.open("#{directory}/#{self.name}.json", "w") do |file|
          file.write(export_hash.to_json)
        end
      end

      def export_hash
        as_json.merge(entity_types: entity_types_export, intents: intents.as_json, analyzers: analyzers.as_json,
                           training_phrases: training_phrases.as_json)
      end

      def entity_types_export
        entity_types.map do |et|
          et_json = et.as_json
          items_json = et.entity_items.map(&:as_json)
          et_json.merge(entity_items: items_json)
        end
      end
    end
  end
end
