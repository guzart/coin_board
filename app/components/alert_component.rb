class AlertComponent < ApplicationComponent
  param :message, default: proc { nil }

  # https://getbootstrap.com/docs/5.3/components/alerts/
  option :variant, default: proc { :primary }

  slim_template <<~SLIM
    div[class=root_class id=id data=data]
      = message_or_content
  SLIM

  private

  def root_class
    "alert alert-#{variant} #{class_name}"
  end

  def message_or_content
    message || content
  end
end
