module Utils
  module UserRegexNormalizer
    def normalize(regex_value)
      regex_value.gsub(" ", "\\s")
    end
    module_function :normalize

    def denormalize(regex_value)
      regex_value.gsub("\\s", " ")
    end
    module_function :denormalize
  end
end
