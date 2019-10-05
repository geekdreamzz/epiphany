module Epiphany
  module EntityTypes
    module Importer

      # TODO this needs to be abstracted into configuration - since you are just hacking this
      # just add a "default fields" property option for entity_types
      # for the landing page launch
      def fields
        name == 'exercise' ? exercise_fields : macro_fields
      end

      def macro_fields
        ['name', 'calories', 'protein', 'carbs', 'fat', 'default serving count', 'serving metric']
      end

      def exercise_fields
        ['name']
      end
      # END

    end
  end
end