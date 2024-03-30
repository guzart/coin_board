module ButtonHelper
  def toggle_modal_button(label, selector:, **options)
    ButtonComponent.new label, data: { controller: "toggle-modal", toggle_modal_selector_value: selector }, **options
  end
end
