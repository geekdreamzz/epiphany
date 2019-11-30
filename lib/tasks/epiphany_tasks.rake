namespace :epiphany do

  # rake epiphany:export_all
  # dumps the latest data into json for each voice assistant, including entity_types, entity_items, analyzers, intents,
  # and training_phrases ...into a central location....and will also save backups with timestamps
  #
  task :export_all => :environment do
    folder_name = Time.now.strftime("%Y%m%d%H%M%S")
    dir = Rails.root.to_s + "/lib/epiphany_exports/#{folder_name}"
    FileUtils.mkdir_p(dir)
    Epiphany::VoiceAssistant.all.each do |voice_assistant|
      voice_assistant.export_to_json(dir)
    end
  end

  # rake epiphany:seed_sample_data
  # imports the above json into any environment, quick easy way to share entity data - especially for demos
  # and general knowledge / config sharing
  #
  task :seed_sample_data => :environment do
    Epiphany::VoiceAssistant.import_from_default_json!
  end
end
