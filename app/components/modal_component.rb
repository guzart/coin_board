class ModalComponent < ApplicationComponent
  param :title, optional: true
  option :title_tag, default: proc { :h5 }

  slim_template <<~SLIM
    div[class=root_class id=id data=root_data aria=root_aria tabindex="-1"]
      .modal-dialog
        .modal-content
          - if title.present?
            .modal-header
              *{ tag: title_tag, id: title_id, class: "modal-title" }
                = title
              = close_button
          .modal-body
            = content
  SLIM

  private

  def root_class
    "modal fade #{class_name}"
  end

  def root_data
    data.merge(controller: "modal")
  end

  def root_aria
    aria.merge(hidden: "true", labelledby: title_id)
  end

  def title_id
    "#{id_with_fallback}-title"
  end

  def close_button
    button_tag("", class: "btn-close", type: "button", data: { bs_dismiss: "modal", bs_label: "Close" })
  end
end
