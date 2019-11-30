Epiphany::Engine.routes.draw do
  root to: 'home#index'
  resources :voice_assistants do

    resources :phrases

    resources :entity_types do
      collection do
        post '/:id', to: "entity_types#add_items"
        post '/:id/csv', to: "entity_types#csv_import"
      end
    end

    resources :entity_items do
      collection do
        post '/:id', to: "entity_items#process_metadata"
      end
    end

    resources :intents do
      collection do
        post '/:id', to: "intents#create" # this also can handle update
      end
    end

    resources :analyzers do
      collection do
        post '/:id', to: "analyzers#create" # this also can handle update
      end
    end

  end

  namespace :api do
    resources :voice_assistants, only: :show
  end
end
