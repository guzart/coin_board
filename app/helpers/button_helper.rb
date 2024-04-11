module ButtonHelper
  def toggle_modal_button(label, selector:, **options)
    ButtonComponent.new label, data: { controller: "toggle-modal", toggle_modal_selector_value: selector }, **options
  end

  def toggle_modal_button_options(selector, **options)
    { data: { controller: "toggle-modal", toggle_modal_selector_value: selector } }.deep_merge(options)
  end

  def delete_button_options_for(resource, options = {})
    data = { turbo_method: :delete,
             turbo_confirm: t("messages.confirm_delete", name: resource.to_s) }
    { href: url_for(resource), variant: :danger, data: }.deep_merge(options)
  end
end
