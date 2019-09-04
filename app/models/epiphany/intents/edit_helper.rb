module Epiphany
  module Intents
    module EditHelper

      def selected_show_stopper_id?(_id)
        show_stopper_entity_type_ids.include?(_id)
      end

      def selected_required_entity_type_id?(_id)
        required_entity_type_ids.include?(_id)
      end

      def selected_boosted_entity_id?(_id)
        boosted_entity_type_ids.include?(_id)
      end

      def entity_type_order_list_string
        entity_type_ordered_list.join(', ')
      end

      def display_entity_items_html
        tokenized_entity_items.map do |entity_item|
          "#{entity_item.entity_type.name}: #{entity_item.name}"
        end.join('<br/>').html_safe
      end

    end
  end
end
