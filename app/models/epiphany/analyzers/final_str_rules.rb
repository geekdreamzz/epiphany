module Epiphany
  module Analyzers
    module FinalStrRules

      def final_str_rules
        serialized_rules['final_str_rules'] || {}
      end

      def token_str_rules
        final_str_rules['forToken']
      end

      def display_value_rules
        final_str_rules['forDisplayValue']
      end

      def blank_token_str_rules?
        token_str_rules.blank?
      end

      def blank_display_value_rules?
        display_value_rules.blank?
      end

      def selected_token_str_rule?(rule)
        return false if blank_token_str_rules?
        token_str_rules[rule].present?
      end

      def selected_token_str_val?(val)
        return false if blank_token_str_rules?
        token_str_rules.find{|_k,v| v == val }.present?
      end

      def selected_display_str_rule?(rule)
        return false if blank_display_value_rules?
        display_value_rules[rule].present?
      end

      def selected_display_str_val?(val)
        return false if blank_display_value_rules?
        display_value_rules.find{|_k,v| v == val }.present?
      end

    end
  end
end
