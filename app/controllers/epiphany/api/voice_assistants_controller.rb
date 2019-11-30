module Epiphany
  module Api
    class VoiceAssistantsController < ApplicationController
      def show
        voice_assistant = Epiphany::VoiceAssistant.find(params[:id])
        render json: voice_assistant.calculate_intent_of(params[:phrase]).api_response
      end
    end
  end
end
