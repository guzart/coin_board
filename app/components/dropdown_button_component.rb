class DropdownButtonComponent < ApplicationComponent
  include ButtonContentProps
  include ButtonAppearanceProps

  TOGGLE_CLASS = "dropdown-toggle".freeze

  renders_many :menu_items, "MenuItemComponent"

  option :show_toggle_icon, default: proc { true }

  slim_template <<~SLIM
    = content_tag(:div, class: root_class_name, data: root_data, id:)
      = render(ButtonComponent.new(button_content, **toggle_button_props))
      ul.dropdown-menu
        - menu_items.each do |menu_item|
          = menu_item
  SLIM

  private

  def root_class_name
    "btn-group #{class_name}"
  end

  def root_data
    data.merge(controller: "dropdown-button")
  end

  def toggle_button_props
    button_appearance_props.merge(button_content_props).merge(
      class: "#{TOGGLE_CLASS} #{show_toggle_class_name}",
      data: data.merge(dropdown_button_target: "toggle")
    )
  end

  def show_toggle_class_name
    show_toggle_icon ? "" : "hide-toggle-icon"
  end

  class MenuItemComponent < ApplicationComponent
    param :label, default: proc { "" }
    option :href, optional: true
    option :icon, optional: true
    option :divider, default: proc { false }

    slim_template <<~SLIM
      = content_tag :li, class: class_name do
        - if divider
          hr.dropdown-divider
        - else
          = link_to href, class: "dropdown-item", data: do
            => helpers.icon(icon) if icon
            = label
    SLIM
  end
end
