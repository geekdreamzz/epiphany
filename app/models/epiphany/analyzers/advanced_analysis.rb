module Epiphany
  module Analyzers
    module AdvancedAnalysis
      def advanced_analysis(str_token, matches)
        analyzers.map do |analyzer|
          analyzer.analyze(str_token, matches)
        end
      end
    end
  end
end
