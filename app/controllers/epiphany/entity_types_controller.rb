require_dependency "epiphany/application_controller"

module Epiphany
  class EntityTypesController < ApplicationController
    include ApplicationHelper

    def index
      @entity_types = current_assistant.entity_types
    end

    def create
      current_assistant.create_entity_type(entity_type_params)
      redirect_to(generate_url('/entity_types'))
    end

    def show
      @entity_type = EntityType.find(params[:id])
    end

    def add_items
      current_entity_type.add_items(params[:key_phrases])
      redirect_to(generate_url('/entity_types'))
    end

    def entity_type_params
      params.permit(:entity_type_name, :key_phrases)
    end

    def current_entity_type
      current_assistant.entity_types.find{|et| et.id == params[:id].to_i }
    end
  end
end
