require_dependency "epiphany/application_controller"

module Epiphany
  class VoiceAssistantsController < ApplicationController
    skip_before_action :reroute_unless_assistant, only: :create
    skip_before_action :current_assistant, only: :create

    def create
      VoiceAssistant.create(create_params)
      redirect_to('/')
    end

    private
    def create_params
      params[:name] = params[:voice_assistant_name]
      params[:description] = params[:voice_assistant_description]
      params.permit(:name, :description)
    end
  end
end
