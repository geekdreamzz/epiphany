module Epiphany
  class EntityItem < ApplicationRecord
    belongs_to :entity_type

    class << self

      def matches(ids)
        where(id: ids)
      end

      #fragments is an array of strings. Tokenized from original phrase
      def str_token_matches(str_tokens)
        where(name: str_tokens)
      end

      def match_ids(str_tokens)
        str_token_matches(str_tokens).pluck(:id)
      end
    end
  end
end
