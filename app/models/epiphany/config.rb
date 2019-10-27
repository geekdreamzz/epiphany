module Epiphany
  class Config

    def auth_handler
      @auth
    end

    def auth=(method_name)
      @auth = method_name
    end

    class << self

      def set
        yield config
      end

      def has_auth?
        config.auth_handler.present?
      end

      def auth
        config.auth_handler
      end

      def config
        @config ||= new
      end

    end
  end
end
