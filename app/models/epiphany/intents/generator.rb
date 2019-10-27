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

      # TODO the intent rules logic is very similar to the analyzer rules logic
      # abstract so it's in a common place
      def generate_metadata_rules_hash(params)
        rules = {
            required_entity_type_ids: [],
            show_stopper_entity_type_ids: [],
            boosted_entity_type_ids: [],
            entity_type_ordered_list: [],
            parts_of_speech: {}
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

          if k.to_s.starts_with?('pos_')
            key = ::Epiphany::Analyzers::PartsOfSpeech::SUPPORTED_FIELDS.find do |field|
              field == k.split('pos_').last
            end

            val = ::Epiphany::Analyzers::PartsOfSpeech::VALUE_OPTIONS.find do |opt|
              opt == v.strip
            end

            # parts of speech fields / vals are enforced in the above constants
            next unless key && val
            rules[:parts_of_speech][key] = val
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
