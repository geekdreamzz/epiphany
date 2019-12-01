module Epiphany
  module OnSave

    def normalize_name
      return false if name.blank?
      self.name = name.strip.downcase
    end

  end
end
