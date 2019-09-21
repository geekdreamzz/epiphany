module Epiphany
  module Phrases
    module Responder

      def response
        @response ||= phrase #default
      end

      def response=(_response)
        @response = _response
      end

    end
  end
end