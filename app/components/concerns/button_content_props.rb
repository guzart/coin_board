module ButtonContentProps
  extend ActiveSupport::Concern

  included do
    param :label, optional: true
    option :href, optional: true
    option :type, default: proc { :button }

    private

    def button_content_props
      { label:, type:, href: }
    end

    def link?
      href.present?
    end

    def label_or_content
      return label if label.present?

      content
    end
  end
end
