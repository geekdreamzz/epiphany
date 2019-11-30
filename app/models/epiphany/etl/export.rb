module Epiphany
  module Etl
    module Export
      EXPORT_DIR = (Rails.root.to_s + "/lib/epiphany_exports/").freeze

      # mostly just for demoing and seeding data, but there's likely real "use cases" where you want to
      # export / import data from a json file
      def export_to_json(directory)
        # at the root of the export directory - signaling its the "latest" export
        File.open("#{EXPORT_DIR}#{self.name}.json", "w") do |file|
          file.write(export_hash.to_json)
        end

        # saves to dir with a timestamped name as a backup
        File.open("#{directory}/#{self.name}.json", "w") do |file|
          file.write(export_hash.to_json)
        end
      end

      def export_hash
        as_json.merge(entity_types: entity_types_export, intents: intents.as_json, analyzers: analyzers_export,
                           training_phrases: training_phrases.as_json)
      end

      def analyzers_export
        analyzers.map do |a|
          a.as_json.merge(entity_type: a.entity_type.as_json)
        end
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
