module Epiphany
  module Intents
    module CalculateScore

      def calculate_with(tokenized_entity_items, phrase)
        @tokenized_entity_items = tokenized_entity_items
        @score = 0
        @phrase = phrase
        return self if show_stoppers? || !has_required_entities?

        entity_type_ids_for_calculation.each do |entity_type_id|
          match = tokenized_entity_items.find do |entity_item|
            entity_item.entity_type_id == entity_type_id
          end
          @score += match.name.length if match
        end

        self
      end

      def phrase_text
        phrase.phrase
      end

      def result_text
        calculated_intent? ? name_with_score : "unable to calculate"
      end

      def name_with_score
        "#{name} score: #{score}"
      end

      def calculated_intent?
        score.present? && score > 0
      end

      def matched_entity_type_ids
        tokenized_entity_items.map(&:entity_type_id)
      end

      def entity_type_ids_for_calculation
        required_entity_type_ids + boosted_entity_type_ids
      end

    end
  end
end