require "mail"

class Mail::Message
  attr_accessor :uid

  def authenticated?
    spf_pass? || dkim_pass?
  end

  def spf_pass?
    spf_field&.value&.include?(" spf=pass ")
  end

  def dkim_pass?
    dkim_field&.value&.include?(" dkim=pass ")
  end

  def authentication_field
    header_fields.find { |field| field.name == "Authentication-Results" }
  end
end
