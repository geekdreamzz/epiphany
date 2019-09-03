require_dependency "epiphany/application_controller"

module Epiphany
  class HomeController < ApplicationController
    skip_before_action :reroute_unless_assistant

    def index
      @voice_assistants = VoiceAssistant.all
    end
  end
end
