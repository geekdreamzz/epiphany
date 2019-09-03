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

    end
  end
end
