module Epiphany
  module Intents
    module RulesHelper

      def has_required_entities?
        union_of = required_entity_type_ids.sort & matched_entity_type_ids.sort
        required_entity_type_ids.sort == union_of
      end

      def show_stoppers?
        (show_stopper_entity_type_ids & matched_entity_type_ids).present?
      end

      def show_stopper_entity_type_ids
        serialized_rules['show_stopper_entity_type_ids'] || []
      end

      def required_entity_type_ids
        serialized_rules['required_entity_type_ids'] || []
      end

      def boosted_entity_type_ids
        serialized_rules['boosted_entity_type_ids'] || []
      end

      def entity_type_ordered_list
        serialized_rules['entity_type_ordered_list'] || []
      end

      def parts_of_speech_rules
        serialized_rules['parts_of_speech'] || {}
      end

      def serialized_rules
        JSON.parse(metadata) || {}
      end

    end
  end
end
