module ButtonHelper
  def toggle_modal_button(label, selector:, **options)
    ButtonComponent.new label, data: { controller: "toggle-modal", toggle_modal_selector_value: selector }, **options
  end

  def delete_button_options_for(resource, options = {})
    options.merge(variant: :danger,
                  data: { turbo_method: :delete,
                          turbo_confirm: t("messages.confirm_delete", name: resource.to_s) })
  end
end
