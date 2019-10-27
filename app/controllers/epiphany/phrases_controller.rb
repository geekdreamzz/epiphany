require_dependency "epiphany/application_controller"

module Epiphany
  class PhrasesController < ApplicationController

    def index
      Analyzer.purge_items

      #TODO lazy load in ajax & add paging
      @phrases = current_assistant.training_phrases.last(count)
    end

    def count
      params[:count] || 15
    end

    def create
      current_assistant.save_training_phrase(phrase_params)
      redirect_to(generate_url('/phrases'))
    end

    def phrase_params
      params.permit(:training_phrase)
    end
  end
end
