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
          # we gsub / remove prev detected advanced analyzer tokens
          next unless m.entity_type.analyzer_id.present?
          next if entity_type_ordered_list.include?(m.entity_type.name)
          _str_token = _str_token.gsub(m.name, '')
        end

        # Start loop to determine derived value
        _str = ''
        valid = false
        str_matched_entity_type_ids = []
        entity_type_ordered_list.each_with_index do |entity_type_name, idx|

          # ignore token matches of the same current analyzer
          # @_matches = matches.select{|m| m.entity_type_id != self.id} if idx == 0
          @_matches = matches if idx == 0

          match = nil
          @keyword_hits ||= ''
          @_matches.each do |_match|
            next unless _match.entity_type.name == entity_type_name.strip

            # entity_type_ordered_list is the order of entity types for some display value
            # if we make it here, we have a possible match
            keyword_hit = _match.variations.find{|variation| _str_token.include?(variation) }

            if keyword_hit
              match = _match
              str_dix = _str_token.index(keyword_hit)
              _str_token = (_str_token[str_dix.._str_token.length]).to_s
              @keyword_hits << "#{keyword_hit.strip} "
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