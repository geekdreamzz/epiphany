module Epiphany
  module Analyzers
    module Debugger

      def delete_all_analyzer_items
        entity_type_ids = Epiphany::Analyzer.all.pluck(:entity_type_id)
        Epiphany::EntityItem.where(entity_type_id: entity_type_ids).destroy_all
      end

    end
  end
end