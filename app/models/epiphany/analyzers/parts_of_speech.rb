module Epiphany
  module Analyzers

    # included in analyzer.rb & intent.rb
    module PartsOfSpeech
      SUPPORTED_FIELDS = %w{ is_question }
      REQUIRED = 'required'
      SHOW_STOPPER = 'show_stopper'
      BOOSTED = 'boosted'
      VALUE_OPTIONS = [REQUIRED,SHOW_STOPPER,BOOSTED].freeze

      QUESTION_REGEX = /^(how\b|what\b|who\b|why\b|when\b|whose\b|whom\b|which\b|where\b)|\?$/i

      def meets_parts_of_speech_validation?
        return true if parts_of_speech_rules.blank?
        valid_required_pos_fields? && !has_show_stopper_pos?
      end

      def valid_required_pos_fields?
        fields[REQUIRED].keys.map do |field|
          send(field)
        end.all?
      end

      def has_show_stopper_pos?
        fields[SHOW_STOPPER].keys.map do |field|
          send(field)
        end.any?
      end

      def fields
        {
            REQUIRED => get_fields_by_val(REQUIRED),
            SHOW_STOPPER => get_fields_by_val(SHOW_STOPPER),
            BOOSTED => get_fields_by_val(BOOSTED)
        }
      end

      def get_fields_by_val(val)
        parts_of_speech_rules.select{|k,v| val == v }
      end

      def parts_of_speech_rules
        serialized_rules['parts_of_speech'] || {}
      end

      def has_parts_of_speech_rules?
        parts_of_speech_rules.blank?
      end

      ### FIELDS / METHODS ###
      #
      # ultimately each field maps to a method
      # so no ? mark since it's almost metaprogrammed and persisted thru diff clients
      # it's easier to persist this simple string while also normalizing it to some
      # method, hash_key or prop/object type
      def is_question
        # @str_token is when this module is included in the analyzer
        # phrase.phrase is when this module is included in intent.rb to calculate scores
        # we could refactor cuz its kinda confusing but this method is the only time there is any variance
        # w/ in this ~module
        val = @str_token || phrase.phrase
        val.match(QUESTION_REGEX).present?
      end

    end
  end
end
