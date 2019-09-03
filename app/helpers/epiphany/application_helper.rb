module Epiphany
  module ApplicationHelper

    # current_assistant = Epiphany::VoiceAssistant.find(1)
    # comment is here so i can copy and paste into the console when needed
    def current_assistant
      @current_assistant
    end

    def assistant_base_url
      current_assistant.present? ? "/voice_assistants/#{current_assistant.id}" : ''
    end

    def generate_url(path)
      assistant_base_url.present? ? assistant_base_url + path : '/?a=1'
    end

    def tokenize_phrase(phrase)
      current_assistant.tokenize(phrase)
    end

    def entity_matches(phrase)
      tokenize_phrase(phrase).map{|p| "#{p.entity_type.name}: #{p.name}" }.join("<br/>").html_safe
    end

    def all_analyzers
      current_assistant&.analyzers || []
    end

    def all_intents
      current_assistant&.intents || []
    end

    def all_entity_types
      current_assistant&.all_entity_types || []
    end
  end
end
