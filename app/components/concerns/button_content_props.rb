module ButtonContentProps
  extend ActiveSupport::Concern

  included do
    param :label, optional: true
    option :href, optional: true
    option :type, default: proc { :button }
    option :icon, optional: true

    private

    def button_content_props
      { label:, type:, href: }
    end

    def link?
      href.present?
    end

    def button_content
      return label_or_content unless icon

      helpers.icon(icon).concat(" ").concat(label_or_content)
    end

    def label_or_content
      return label if label.present?

      content
    end
  end
end
