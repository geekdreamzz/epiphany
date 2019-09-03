module Epiphany
  class ApplicationController < ActionController::Base
    include ApplicationHelper
    protect_from_forgery with: :exception
    before_action :current_assistant
    before_action :reroute_unless_assistant

    def reroute_unless_assistant
      redirect_to('/?a=1') if get_assistant.blank?
    end

    def current_assistant
      get_assistant
    end

    def get_assistant
      session[:voice_assistant_id] = params[:voice_assistant_id] if params[:voice_assistant_id]
      session[:voice_assistant_id] = nil unless VoiceAssistant.exists?(session[:voice_assistant_id])

      if session[:voice_assistant_id].present?
        @current_assistant = VoiceAssistant.find(session[:voice_assistant_id])
      else
        @current_assistant = VoiceAssistant.last
      end
    end
  end
end
