module Epiphany
  module OnSave

    def normalize_name
      self.name = name.strip.downcase
    end

    # primarily for entity_items model - START - TODO move to sep file.
    def default_variations
      unless self.variations.present?
        self.variations = grammar_array
      end
    end

    # TODO other parts of speech / tense ... ~run, ran, running, eat, ate, etc.
    # for now it just saves the singular / plural form automatically
    def grammar_array
      _array = [
          name,
          name.singularize.pluralize,
          name.singularize
      ].uniq
    end

    def process_update(params)
      process_metadata(params[:entity_item_metadata])
      process_variations(params[:variations])
      self.save
    end

    def process_variations(variations)
      _variations = variations.split(',').map(&:strip)
      self.variations = (grammar_array + _variations).uniq
    end

    def process_metadata(metadata)
      return unless metadata.present? && metadata.is_a?(String)
      _metadata = JSON.parse(metadata)
      valid = _metadata.map do |k,v|
        k.present? && v.present?
      end.all?
      self.metadata = metadata if valid
    end
    # primarily for entity_items model - END

  end
end
