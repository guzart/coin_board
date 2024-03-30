class ButtonComponent < ApplicationComponent
  include ButtonAppearanceProps
  include ButtonContentProps

  def call
    if link?
      link_to(content, href, class: root_class, id:, data:, aria:)
    else
      button_tag(content, class: root_class, type:, id:, data:, aria:)
    end
  end

  private

  def root_class
    "btn #{appearance_class_names} #{class_name}"
  end
end
