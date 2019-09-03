require_dependency "epiphany/application_controller"

module Epiphany
  class IntentsController < ApplicationController

    #also handles updates
    def create
      current_assistant.create_or_update_intent(params)
      redirect_to(generate_url('/intents'))
    end

  end
end
