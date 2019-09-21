module Epiphany
  module Analyzers
    # included in Analyzers::Base which is then included in voice_assistant.rb
    # confusing, too many mixins should refactor
    module AdvancedAnalysis
      def advanced_analysis(str_token, matches)
        analyzers.map do |analyzer|
          analyzer.analyze(str_token, matches)
        end
      end
    end
  end
end
