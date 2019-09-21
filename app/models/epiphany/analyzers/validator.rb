module Epiphany
  module Analyzers
    module Validator

      def final_validation_passed?(_str)
        _str = _str.strip.presence
        return false unless _str
        acceptable_diff?(_str) && valid_proximity?(_str)
      end

      # you need at least 50 % of the entity order name
      # this is confusing even to me, need to clean up this logic
      # but given you have all "required" entities in a str, the truthy val might just a subset of the full string
      # ex: 5 oz ribeye and analyzer is serving size, which would be "5 oz"
      # so we want to return that val (w/o ribeye) for that analyzer
      # 5 oz is > 50 % of the phrase 5 oz ribeye & a lot of validation steps
      # happen before it gets here but this is the final validator.
      # It seems to work ok, but it's def a crazy hack. if it works it works i guess.
      # likely will need to revisit...
      def acceptable_diff?(_str)
        frags = self.class.fragmenter(_str)
        _matches = matches.select do |match|
          frags.include?(match.name.downcase) && entity_type_ordered_list.include?(match.entity_type.name)
        end
        diff = _matches.length.to_f / entity_type_ordered_list.length.to_f
        diff > 0.5
      end

      # also found these words need to be in close proximity to each other to make sense
      # it's starting to get really hacky and this where ~true ML analysis excels
      # but still pushing forward cuz I think i can still achieve powerful results if I just power thru
      # my validation rules. Doing this with real ML, getting lots of training data, and constantly
      # training it would be a nightmare also... so I'm not too worried about hacking right now
      def valid_proximity?(_str)
        words = _str.split(' ')
        max_proximity_count = words.length * 3
        proximity_count = 0
        words.map{|w| str_token.index(w) }.sort.reverse.each_with_index do |str_idx, idx|
          if idx == 0
            proximity_count = str_idx
            next
          end
          proximity_count -= str_idx
        end
        max_proximity_count >= proximity_count
      end

    end
  end
end
