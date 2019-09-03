class CreateEpiphanyVoiceAssistants < ActiveRecord::Migration[Rails.version.to_f]
  def change
    create_table :epiphany_voice_assistants do |t|
      t.string :name, null: false
      t.text :description
      t.timestamps
    end
    add_index(:epiphany_voice_assistants, [:name], name: 'epiphany_voice_assistants_name_idx')

    create_table :epiphany_entity_types do |t|
      t.string :name, null: false
      t.integer :voice_assistant_id, null: false
      t.integer :analyzer_id
      t.timestamps
    end
    add_index(:epiphany_entity_types, [:name], name: 'epiphany_entity_types_name_idx')
    add_index(:epiphany_entity_types, [:voice_assistant_id], name: 'epiphany_entity_types_voice_assistant_id_idx')
    add_index(:epiphany_entity_types, [:voice_assistant_id, :name], name: 'epiphany_entity_types_voice_assistant_id_name_idx')
    add_index(:epiphany_entity_types, [:voice_assistant_id, :name, :analyzer_id], name: 'epiphany_entity_types_voice_assistant_id_name_analyzer_idx')
    add_index(:epiphany_entity_types, [:name, :analyzer_id], name: 'epiphany_entity_types_name_analyzer_idx')
    add_index(:epiphany_entity_types, [:analyzer_id], name: 'epiphany_entity_types_analyzer_idx')
    add_index(:epiphany_entity_types, [:analyzer_id, :voice_assistant_id], name: 'epiphany_entity_types_voice_assistant_analyzer_idx')

    create_table :epiphany_entity_items do |t|
      t.string :name, null: false
      t.integer :entity_type_id, null: false
      t.text :metadata, default: '{}'
      t.timestamps
    end
    add_index(:epiphany_entity_items, [:name], name: 'epiphany_entity_items_name_idx')
    add_index(:epiphany_entity_items, [:entity_type_id], name: 'epiphany_entity_items_entity_type_id_idx')
    add_index(:epiphany_entity_items, [:entity_type_id, :name], name: 'epiphany_entity_items_name_entity_type_id_idx')

    create_table :epiphany_intents do |t|
      t.string :name, null: false
      t.integer :voice_assistant_id, null: false
      t.text :rules, default: '{}'
      t.timestamps
    end
    add_index(:epiphany_intents, [:name], name: 'epiphany_intents_name_idx')
    add_index(:epiphany_intents, [:voice_assistant_id], name: 'epiphany_intents_voice_assistant_id_idx')
    add_index(:epiphany_intents, [:voice_assistant_id, :name], name: 'epiphany_intents_voice_assistant_name_id_idx')

    create_table :epiphany_analyzers do |t|
      t.string :name, null: false
      t.integer :voice_assistant_id, null: false
      t.integer :entity_type_id
      t.text :rules, default: '{}'
      t.timestamps
    end
    add_index(:epiphany_analyzers, [:name], name: 'epiphany_analyzers_name_idx')
    add_index(:epiphany_analyzers, [:voice_assistant_id], name: 'epiphany_analyzers_voice_assistant_id_idx')
    add_index(:epiphany_analyzers, [:voice_assistant_id, :name], name: 'epiphany_analyzers_voice_assistant_id_name_idx')
    add_index(:epiphany_analyzers, [:voice_assistant_id, :name, :entity_type_id], name: 'epiphany_analyzers_voice_assistant_id_name_entity_type_id_idx')
    add_index(:epiphany_analyzers, [:name, :entity_type_id], name: 'epiphany_analyzers_name_entity_type_id_idx')
    add_index(:epiphany_analyzers, [:entity_type_id], name: 'epiphany_analyzers_entity_type_id_idx')
    add_index(:epiphany_analyzers, [:entity_type_id, :voice_assistant_id], name: 'epiphany_analyzers_entity_type_id_voice_assistant_id_idx')

    create_table :epiphany_training_phrases do |t|
      t.text :phrase, null: false
      t.integer :voice_assistant_id, null: false
      t.text :metadata, default: '{}'
      t.timestamps
    end
    add_index(:epiphany_training_phrases, [:phrase], name: 'epiphany_training_phrases_idx')
    add_index(:epiphany_training_phrases, [:voice_assistant_id], name: 'epiphany_training_voice_assistant_id_idx')
    add_index(:epiphany_training_phrases, [:voice_assistant_id, :phrase], name: 'epiphany_training_phrases_name_voice_assistant_id_idx')
  end
end
