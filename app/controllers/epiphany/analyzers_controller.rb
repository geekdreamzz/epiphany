require_dependency "epiphany/application_controller"

module Epiphany
  class AnalyzersController < ApplicationController

    def index

    end

    #also handles updates
    def create
      current_assistant.create_or_update_advanced_analyzer(params)
      redirect_to(generate_url('/analyzers'))
    end
  end
end
