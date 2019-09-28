require_dependency "epiphany/application_controller"

module Epiphany
  class EntityItemsController < ApplicationController

    def process_metadata
      entity_item.process_update(params)
      redirect_to(generate_url('/entity_types/' + entity_item.entity_type_id.to_s))
    end

    def entity_item
      current_assistant.entity_items.find(params[:id])
    end

  end
end
