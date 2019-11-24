namespace :epiphany do
  task :export_all => :environment do
    folder_name = Time.now.strftime("%Y%m%d%H%M%S")
    dir = Rails.root.to_s + "/lib/epiphany_exports/#{folder_name}"
    FileUtils.mkdir_p(dir)
    Epiphany::VoiceAssistant.all.each do |voice_assistant|
      voice_assistant.export_to_json(dir)
    end
  end
end
