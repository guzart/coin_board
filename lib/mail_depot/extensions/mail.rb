require "mail"

# rubocop:disable Style/ClassAndModuleChildren
class Mail::Message
  attr_accessor :uid

  def authenticated?
    spf_pass? || dkim_pass?
  end

  def spf_pass?
    authentication_field&.value&.include?(" spf=pass ")
  end

  def dkim_pass?
    authentication_field&.value&.include?(" dkim=pass ")
  end

  def authentication_field
    @authentication_field ||= header_fields.find { |field| field.name == "Authentication-Results" }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
