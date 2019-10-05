module Epiphany
  module Analyzers
    module Validator

      def final_validation_passed?(_str)
        _str = _str.strip.presence
        return false unless _str
        @current_str = _str
        valid_token_rules?(_str) && valid_display_val_rules?(_str)
      end

      def valid_token_rules?(_str)
        return true if blank_token_str_rules?
        token_str_rules.map do |k,v|
          _entity_type = matches.find{|m| m.entity_type.name == v }
          vals = []
          vals = _entity_type.variations if _entity_type.present?
          str_rule_validator(k, vals, str_token)
        end.all?
      end

      def valid_display_val_rules?(_str)
        return true if blank_display_value_rules?
        display_value_rules.map do |k,v|
          _entity_type = matches.find{|m| m.entity_type.name == v }
          vals = []
          vals = _entity_type.variations if _entity_type.present?
          str_rule_validator(k, vals, _str)
        end.all?
      end

      def str_rule_validator(rule, vals, str_to_validate)
        case rule
        when "must start with"
          vals.find{|val| str_to_validate.starts_with?(val)}.present?
        when "must end with"
          vals.find{|val| str_to_validate.ends_with?(val)}.present?
        when "cannot start with"
          vals.find{|val| str_to_validate.starts_with?(val)}.blank?
        when "cannot end with"
          vals.find{|val| str_to_validate.ends_with?(val)}.blank?
        when "cannot be preceded by"
          vals.find do |val|
            idx_of_val = str_token.index(val)
            idx_of_current_str = str_token.index(@current_str)
            if idx_of_val && idx_of_current_str
              idx_of_current_str > idx_of_val
            end
          end.blank?
        else
          false
        end
      end

    end
  end
end
