module Epiphany
  module EntityItems
    module VariationsSave

      def default_variations
        unless self.variations.present?
          self.variations = normalized_variations
        end
      end

      def normalized_variations
        (grammar_array + gsub_array).compact.uniq
      end

      # TODO other parts of speech / tense ... ~run, ran, running, eat, ate, etc.
      def grammar_array
        [ name, name.singularize.pluralize, name.singularize ].uniq
      end

      def gsub_array
        grammar_array.map do |text|
          if text.match(gsub_regex)
            [
                text.gsub(gsub_regex, ' '),
                text.gsub(gsub_regex, '')
            ]
          end
        end.flatten.uniq
      end

      def process_update(params)
        self.name = params[:name]
        process_metadata(params[:entity_item_metadata])
        process_variations(params[:variations])
        self.save
      end

      def gsub_regex
        /-|'s/i
      end

      def process_variations(variations)
        _variations = variations.split(',').map(&:strip)
        self.variations = (normalized_variations + _variations).uniq
      end

      def process_metadata(metadata)
        return unless metadata.present? && metadata.is_a?(String)
        _metadata = JSON.parse(metadata)
        valid = _metadata.map do |k,v|
          k.present? && v.present?
        end.all?
        self.metadata = metadata if valid
      end

    end
  end
end
