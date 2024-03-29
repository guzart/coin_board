class ButtonComponent < ApplicationComponent
  param :text, optional: true, default: proc { nil }

  # :primary, :secondary, :success, :danger, :warning, :info, :light, :dark
  option :variant, default: proc { :primary }
  # :sm, :lg
  option :size, default: proc { nil }
  option :outline, default: proc { false }
  option :type, default: proc { :button }

  slim_template <<~SLIM
    = button_tag :button, class: root_class, type:, id:, data:
      = text_or_content
  SLIM

  private

  def root_class
    "btn #{variant_class} #{size_class} #{class_name}"
  end

  def text_or_content
    text || content
  end

  def variant_class
    outline_prefix = outline ? "-outline" : ""
    "btn#{outline_prefix}-#{variant}"
  end

  def size_class
    "btn-#{size}" if size.present?
  end
end
