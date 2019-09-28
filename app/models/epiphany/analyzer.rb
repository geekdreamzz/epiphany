module Epiphany
  class Analyzer < ApplicationRecord
    extend Analyzers::Generator
    extend Analyzers::Debugger
    include Analyzers::EditHelper
    include Analyzers::RulesHelper
    include Analyzers::Validator
    include Analyzers::Value
    include Analyzers::PartsOfSpeech
    include OnSave

    before_save :normalize_name

    has_one :entity_type

    attr_accessor :matches, :str_token

    # if analysis == true for this instance of an analyzer
    # it will create the entity item with these analyzers entity type id
    # and then add it the matches array
    # if false it just does not add to the matches & then on to the next
    def analyze(str_token, matches)
      @str_token = str_token
      @matches = matches
      @advance_entity_value = nil
      matches << create_entity_item if valid_entity?
      matches
    end

    def matched_entity_type_ids
      matches.map(&:entity_type_id)
    end

    def create_entity_item
      entity_type.add_items(advance_entity_value)
    end

    def valid_entity?
      !show_stoppers? &&
      has_required_entities? &&
      meets_parts_of_speech_validation? &&
      advance_entity_value
    end

  end
end
