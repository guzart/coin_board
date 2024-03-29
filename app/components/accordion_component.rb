class AccordionComponent < ApplicationComponent
  renders_many :items, lambda { |text = nil, **options|
    AccordionItemComponent.new(text, **options.merge(parent_id: id_with_fallback))
  }

  slim_template <<~SLIM
    = content_tag :div, class: root_class, id: id_with_fallback, data: do
      = content
  SLIM

  private

  def root_class
    "accordion #{class_name}"
  end

  class AccordionItemComponent < ApplicationComponent
    param :text, default: proc { nil }
    option :parent_id
    option :header_tag, default: proc { :h2 }

    renders_one :body, lambda { |content: nil, &block|
      content_tag(:div, id: collapsible_target_id, class: "accordion-collapse collapse",
                        data: { bs_parent: "##{parent_id}" }) do
        content_tag(:div, content, class: "accordion-body", &block)
      end
    }

    slim_template <<~SLIM
      .accordion-item
        = content_tag(header_tag, class: "accordion-header") do
          = header_button
        = body
    SLIM

    private

    def text_or_content
      text || content
    end

    def header_button
      data = { controller: "collapse", bs_toggle: "collapse", bs_target: "##{collapsible_target_id}" }
      button_tag text_or_content, type: :button, class: "accordion-button collapsed", data:,
                                  aria: { expanded: "false", controls: collapsible_target_id }
    end

    def collapsible_target_id
      "#{id_with_fallback}-body"
    end
  end
end
