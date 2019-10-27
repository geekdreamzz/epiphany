module Epiphany
  class ApplicationController < ActionController::Base
    include ApplicationHelper

    # includes parent apps helpers, mostly for custom auth callbacks
    # maybe there's a cleaner way? you basically need to call
    # config.rb set method and assign a string/symbol of a method name
    # that will later be called as an "auth" before action
    include Rails.application.helpers

    protect_from_forgery with: :exception
    before_action :auth
    before_action :current_assistant
    before_action :reroute_unless_assistant

    def auth
      send(Config.auth) if Config.has_auth?
    end

    def reroute_unless_assistant
      redirect_to('/epiphany?a=1') if get_assistant.blank?
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
