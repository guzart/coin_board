class StatusBadgeComponent < ApplicationComponent
  param :text, optional: true
  option :variant, default: proc { :primary }

  slim_template <<~SLIM
    = content_tag :div, class: root_class, id:, data: do
      = content_tag :div, class: status_wrapper_class do
        = content_tag :div, "", class: status_class
      = content_tag :p, text_or_content, class: content_class
  SLIM

  private

  def root_class
    "d-inline-flex align-items-center column-gap-1 #{class_name}"
  end

  def status_wrapper_class
    "flex-grow-0 flex-shrink-0 rounded-circle bg-#{variant}-subtle p-1"
  end

  def status_class
    "h-1 w-1 rounded-circle bg-#{variant}"
  end

  def content_class
    "d-inline text-xs lh-base text-secondary m-0"
  end

  def text_or_content
    text || content
  end
end
