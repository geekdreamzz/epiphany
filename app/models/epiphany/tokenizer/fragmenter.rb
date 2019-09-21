module Epiphany
  module Tokenizer
    class Fragmenter
      class << self

        # cache this output
        def fragmenter(_string)
          fragments = _string.split(' ')
          end_idx = fragments.length
          (0..end_idx).map do |idx|
            (idx..end_idx).map do |idx2|
              str = fragments[idx..idx2].join(' ')&.downcase&.presence
              frag_variations(str) if str
            end.flatten.uniq.compact
          end.flatten.uniq.compact #TODO def. optimize this later
        end

        def frag_variations(str)
          [
              str, #always keep original
              str.singularize.pluralize,
              str.singularize,
              prefixed_with_number_regex(str),
              without_special_chars(str)
          ].uniq
        end

        def without_special_chars(str)
          str.gsub(/\W/i,'')
        end

        # it seemed like assuming values like:
        # 8am, 10oz, 10lbs etc, it be good to split them?
        def prefixed_with_number_regex(str)
          if str.match(/(\d+)([a-z]+)$/i)
            str.split(/(\d+)([a-z]+)$/i).last(2)
          end
        end

      end
    end
  end
end