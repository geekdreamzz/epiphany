module Epiphany
  module Analyzers
    module EditHelper

      # TODO rename to show_stopper for consistency
      def selected_showstopper_id?(_id)
        show_stopper_entity_type_ids.include?(_id)
      end

      def selected_required_entity_type_id?(_id)
        required_entity_type_ids.include?(_id)
      end

      def entity_type_order_list_string
        entity_type_ordered_list.join(', ')
      end

      def required_part_of_speech?(pos)
        parts_of_speech_rules[pos] == 'required'
      end

      def show_stopper_part_of_speech?(pos)
        parts_of_speech_rules[pos] == 'show_stopper'
      end

      def boosted_part_of_speech?(pos)
        parts_of_speech_rules[pos] == 'boosted'
      end

      def selected_pos_val?(field, val)
        parts_of_speech_rules[field] == val
      end

    end
  end
end
