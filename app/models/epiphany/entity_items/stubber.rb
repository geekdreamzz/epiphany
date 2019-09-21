module Epiphany
  module EntityItems
    module Stubber

      # intended to be a class method, to stub an instance of an item, but not persist to db
      def stub(entity_type_name, val)
        _entity_type = ::Epiphany::EntityType.find_by_name(entity_type_name)
        return unless _entity_type
        new(name: val, entity_type: _entity_type)
      end

    end
  end
end