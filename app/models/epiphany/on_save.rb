module Epiphany
  module OnSave

    def normalize_name
      self.name = name.strip.downcase
    end

  end
end
