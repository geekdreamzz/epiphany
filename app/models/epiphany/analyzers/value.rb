module Epiphany
  module Analyzers
    module Value

      def advance_entity_value
        return @advance_entity_value if @advance_entity_value
        return str_token if entity_type_ordered_list.blank?

        _str_token = str_token

        same_type_matches = matches.select{|m| m.entity_type_id == self.entity_type_id }
        return if same_type_matches.find{|m| m.name == _str_token }

        same_type_matches.each do |m|
          _str_token = _str_token.gsub(m.name, '')
        end

        # Start loop to determine derived value
        _str = ''
        valid = false
        str_matched_entity_type_ids = []

        entity_type_ordered_list.each_with_index do |entity_type_name, idx|
          @_matches = matches if idx == 0

          match = nil
          @_matches.each do |_match|
            if _match.entity_type.name == entity_type_name.strip && _str_token.include?(_match.name)
              match = _match
              str_dix = _str_token.index(_match.name) + _match.name.length
              _str_token = _str_token[str_dix.._str_token.length]
            end
          end

          next unless match || idx == entity_type_ordered_list.count - 1

          @_matches = @_matches.select{|m| m != match }

          if match
            _str << "#{match.name} "
            str_matched_entity_type_ids << match.entity_type.id
          end

          valid = final_validation_passed?(_str) if idx == entity_type_ordered_list.length - 1
        end
        # end loop to determine derived value (we need to break this logic up)

        @advance_entity_value = valid ? _str.strip : nil
      end

    end
  end
end