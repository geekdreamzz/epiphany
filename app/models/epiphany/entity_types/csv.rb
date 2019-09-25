module Epiphany
  module EntityTypes
    module Csv
      def api_csv
        CSV.generate do |csv|
          csv << fields
          entity_items.each do |e|
            sm = e.serialized_metadata
            csv << [ e.name,
                     fields[1..-1].map do |field|
                       sm[field]
                     end
            ].flatten.compact.uniq
          end
        end
      end

      def import_csv(csv)
        idx = 0
        CSV.foreach(csv.tempfile) do |row|
          if idx == 0
            @headers = row
            idx += 1
            next
          end

          name = row[0].downcase
          metadata = @headers[1..-1].map{|f| [f, row[@headers.index(f)]] }.to_h
          str_metadata = metadata.to_json
          create_or_add_item_w(name, str_metadata)
          idx += 1
        end
      end

      # TODO this needs to be abstracted into configuration - since you are just hacking this
      # for the landing page launch
      def fields
        name == 'exercise' ? exercise_fields : macro_fields
      end

      def macro_fields
        ['name', 'calories', 'protein', 'carbs', 'fat', 'default serving count', 'serving metric']
      end

      def exercise_fields
        ['name']
      end

    end

  end
end
