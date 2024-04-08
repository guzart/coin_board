class EnumSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input(wrapper_options = nil)
    label_method, value_method = detect_collection_methods

    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    @builder.collection_select(
      attribute_name, collection, value_method, label_method,
      input_options, merged_input_options
    )
  end

  private

  def collection
    @collection ||= begin
      enum = options.delete(:enum)
      enum.map { |key, value| [key.to_s.humanize, value] }
    end
  end
end
