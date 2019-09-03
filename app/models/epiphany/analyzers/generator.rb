module Epiphany
  module Analyzers
    module Generator

      def create_from(voice_assistant, params)
        name = params[:advanced_analyzer_name].strip
        rules = stringify_rules(params)

        # analyzer is used to process the rules
        analyzer = if exists?(voice_assistant_id: voice_assistant.id, name: name)
                     a = where(voice_assistant_id: voice_assistant.id, name: name).first
                     a.update(rules: rules)
                     a
                   else
                     create(voice_assistant_id: voice_assistant.id, name: name, rules: rules)
                   end

        # generating the entity type allows it to flow with everything else which ultimately are just a bunch of entities
        # which must belong to an entity type
        unless ::Epiphany::EntityType.exists?(voice_assistant_id: voice_assistant.id, name: name, analyzer_id: analyzer.id)
          entity_type = ::Epiphany::EntityType.create(voice_assistant_id: voice_assistant.id, name: name, analyzer_id: analyzer.id)
        else
          entity_type = ::Epiphany::EntityType.where(voice_assistant_id: voice_assistant.id, name: name, analyzer_id: analyzer.id).first
        end

        analyzer.update(entity_type_id: entity_type.id)
      end

      def generate_metadata_rules_hash(params)
        rules = {
            required_entity_type_ids: [],
            show_stopper_entity_type_ids: [],
            entity_type_ordered_list: []

        }

        params.each do |k,v|
          if k.to_s.starts_with?('required_entity_')
            rules[:required_entity_type_ids] << v.to_i
          end

          if k.to_s.starts_with?('show_stopper_entity_')
            rules[:show_stopper_entity_type_ids] << v.to_i
          end

          if k == 'entity_type_ordered_list' && v.present?
            rules[:entity_type_ordered_list] = v.split(',').map{|val| val.strip }
          end
        end

        rules
      end

      def stringify_rules(params)
        generate_metadata_rules_hash(params).to_json
      end

    end
  end
end