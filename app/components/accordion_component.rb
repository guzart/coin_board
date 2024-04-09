class AccordionComponent < ApplicationComponent
  renders_many :items, lambda { |text = nil, **options|
    AccordionItemComponent.new(text, **options.merge(parent_id: id_with_fallback))
  }

  slim_template <<~SLIM
    div[class=root_class id=id_with_fallback data=data]
      - items.each do |item|
        = item
  SLIM

  private

  def root_class
    "accordion #{class_name}"
  end

  class AccordionItemComponent < ApplicationComponent
    param :text, default: proc { nil }
    option :parent_id
    option :header_tag, default: proc { :h2 }

    renders_one :header
    renders_one :body, lambda { |text = nil, **options, &block|
      BodyComponent.new(text, id: collapsible_target_id, data: body_data, **options, &block)
    }

    slim_template <<~SLIM
      .accordion-item
        *{tag: header_tag, class: "accordion-header"}
          = header_button
        = body
    SLIM

    private

    def text_header_or_content
      text || header || content
    end

    def header_button
      data = { controller: "collapse", bs_toggle: "collapse", bs_target: "##{collapsible_target_id}" }
      button_tag text_header_or_content, type: :button, class: "accordion-button collapsed", data:,
                                         aria: { expanded: "false", controls: collapsible_target_id }
    end

    def collapsible_target_id
      "#{id_with_fallback}-body"
    end

    def body_data
      { bs_parent: "##{parent_id}" }
    end

    class BodyComponent < ApplicationComponent
      param :text, default: proc { nil }

      slim_template <<~SLIM
        .accordion-collapse.collapse[id=id data=data]
          .accordion-body
            = text_or_content
      SLIM

      private

      def text_or_content
        text || content
      end
    end
  end
end
