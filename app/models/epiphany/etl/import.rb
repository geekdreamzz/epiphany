module Epiphany
  module Etl
    module Import
      EXPORT_DIR = Epiphany::Etl::Export::EXPORT_DIR

      # TODO def can abstract this and/or make this cleaner. but making it work for now
      # are clean data importers really thing? =P
      def import_from_default_json!
        Dir[EXPORT_DIR + "*.json"].each do |filename|
          json = JSON.parse(File.read(filename))
          voice_assistant = find_or_create_voice_assistant_from(json)

          # import entity types into the voice assistant
          json['entity_types'].select{|et| et['analyzer_id'].blank? }.each do |et|
            entity_type = voice_assistant.entity_types.find{|et2| et2.name == et['name'] } #inception hell - sorry
            unless entity_type
              entity_type = Epiphany::EntityType.create(name: et['name'], voice_assistant_id: voice_assistant.id)
            end

            #refreshes entity items
            entity_type.entity_items.destroy_all
            et['entity_items'].each do |ei|
              next if Epiphany::EntityItem.exists?(name: ei['name'], entity_type_id: entity_type.id,
                                                   variations: ei['variations'], metadata: ei['metadata'])

              Epiphany::EntityItem.create(name: ei['name'], entity_type_id: entity_type.id,
                                          variations: ei['variations'], metadata: ei['metadata'])
            end
          end

          # import analyzers
          json['analyzers'].each do |a|
            et = a.dig('entity_type')
            entity_type = voice_assistant.entity_types.find{|et2| et2.name == et['name'] }
            unless entity_type
              entity_type = Epiphany::EntityType.create(name: et['name'], voice_assistant_id: voice_assistant.id)
            end

            analyzer = voice_assistant.analyzers.find{|an| an.name == a['name'] }
            unless analyzer
              analyzer = Epiphany::Analyzer.create(name: a['name'], voice_assistant_id: voice_assistant.id,
                                                   entity_type_id: entity_type.id, rules: a['rules'])
            end

            entity_type.update(analyzer_id: analyzer.id)
          end

          #import intents
          json['intents'].each do |intent|
            next if intent['name'].blank?

            _intent = voice_assistant.intents.find{|__intent| __intent.name == intent['name'] }
            unless _intent
              _intent = Epiphany::Intent.create(name: intent['name'], voice_assistant_id: voice_assistant.id,
                                                rules: intent['rules'])
            else
              _intent.update(rules: intent['rules'])
            end
          end

          #import training phrases
          json['training_phrases'].each do |phrase|
            next if phrase['phrase'].blank?

            _phrase = voice_assistant.training_phrases.find{|__phrase| __phrase.phrase == phrase['phrase'] }
            unless _phrase
              _phrase = Epiphany::TrainingPhrase.create(phrase: phrase['phrase'], voice_assistant_id: voice_assistant.id,
                                                metadata: phrase['metadata'])
            else
              _phrase.update(metadata: phrase['metadata'])
            end
          end
        end
        puts 'import complete'
      end

      def find_or_create_voice_assistant_from(json)
        va = find_by_name(json['name'])
        return va if va
        create(name: json['name'], description: json['description'])
      end
    end
  end
end
