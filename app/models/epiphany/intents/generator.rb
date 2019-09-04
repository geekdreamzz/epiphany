module Epiphany
  module Intents
    module Generator

      def create_from(voice_assistant, params)
        name = params[:intent_name].strip
        rules = stringify_rules(params)

        # intent rules are used to calculate intent scores
        if exists?(voice_assistant_id: voice_assistant.id, name: name)
          a = where(voice_assistant_id: voice_assistant.id, name: name).first
          a.update(metadata: rules)
          a
        else
          create(voice_assistant_id: voice_assistant.id, name: name, metadata: rules)
        end
      end

      def generate_metadata_rules_hash(params)
        rules = {
            required_entity_type_ids: [],
            show_stopper_entity_type_ids: [],
            boosted_entity_type_ids: [],
            entity_type_ordered_list: []
        }

        params.each do |k,v|
          if k.to_s.starts_with?('required_entity_')
            rules[:required_entity_type_ids] << v.to_i
          end

          if k.to_s.starts_with?('show_stopper_entity_')
            rules[:show_stopper_entity_type_ids] << v.to_i
          end

          if k.to_s.starts_with?('boosted_entity_')
            rules[:boosted_entity_type_ids] << v.to_i
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
