module Epiphany
  module Analyzers
    module Debugger

      # TODO while developing - entity_items for advanced analyzers can get saved in the DB as wip
      # as rules change, we don't want them anymore. so in development mode it purges the database
      # we can maybe do this better by versioning the analyzers and namespacing the saves?
      # for now I'm wiping it cleaning and re-rerunning the full tokenizer while in dev mode
      def purge_items(force = Rails.env == 'development')
        return unless force
        entity_type_ids = EntityType.where(analyzer_id: Analyzer.pluck(:id)).pluck(:id)
        items = EntityItem.where(entity_type_id: entity_type_ids)
        items.destroy_all
      end

      def fragmenter(_str)
        ::Epiphany::Tokenizer::Fragmenter.fragmenter(_str)
      end

    end
  end
end
