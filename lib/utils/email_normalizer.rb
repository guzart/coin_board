module Utils
  module EmailNormalizer
    def normalize(email)
      email.to_s.downcase.strip
    end
    module_function :normalize
  end
end
