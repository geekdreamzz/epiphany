module Epiphany
  module Analyzers
    module Number
      # id 0 signifies a sys id

      def number_entity_type
        @number_entity_type ||= if Epiphany::EntityType.exists?(name: 'number')
                                  Epiphany::EntityType.find_by_name('number')
                                else
                                  Epiphany::EntityType.create(name: 'number', voice_assistant_id: 0)
                                end
      end

      def create_number(str_token)
        ::Epiphany::EntityItem.create(name: str_token, entity_type_id: number_entity_type.id)
      end

      def is_number?(str_token)
        str_token.to_i.to_s == str_token || str_token.to_f.to_s == str_token
      end

      def create_number?(str_token)
        is_number?(str_token) && !Epiphany::EntityItem.exists?(name: str_token, entity_type_id: number_entity_type.id)
      end

    end
  end
end
