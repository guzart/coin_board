class StatusBadgeComponent < ApplicationComponent
  param :text, optional: true
  option :variant, default: proc { :primary }

  slim_template <<~SLIM
    div[class=root_class id=id data=data]
      div[class=status_wrapper_class]
        div[class=status_class] = ""
      p[class=content_class]
        = text || content
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
end
