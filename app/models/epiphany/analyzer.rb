module Epiphany
  class Analyzer < ApplicationRecord
    extend Analyzers::Generator
    extend Analyzers::Debugger
    include Analyzers::EditHelper
    include Analyzers::RulesHelper

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

    def advance_entity_value
      return @advance_entity_value if @advance_entity_value
      return str_token if entity_type_ordered_list.blank?

      _str_token = str_token

      same_type_matches = matches.select{|m| m.entity_type_id == self.entity_type_id }
      return if same_type_matches.find{|m| m.name == _str_token }

      same_type_matches.each do |m|
        _str_token = _str_token.gsub(m.name, '')
      end

      _str = ''
      valid = false
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

        # TODO we need additional metadata for each item on the entity type ordered list
        # if we mark the order as optional we can let it carry on to the next iteration
        # this check is a temp workaround
        # passthru = false
        # missed_count = nil
        # if match.nil?
        #   missed_count ||= 0
        #   missed_count += 1
        #   passthru = true
        #   match = Epiphany::EntityItem.new(name: '')
        # end

        next unless match

        @_matches = @_matches.select{|m| m != match }

        _str << "#{match.name} "

        valid = _str.present? && idx == entity_type_ordered_list.length - 1
        valid = false if _str.split(' ').length < entity_type_ordered_list.length
      end

      @advance_entity_value = valid ? _str.strip : nil
    end

    def valid_entity?
      !show_stoppers? && has_required_entities? && advance_entity_value
    end

  end
end
