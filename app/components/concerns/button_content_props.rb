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

    alias_method :original_content, :content

    def content
      return label if label.present?

      original_content
    end
  end
end
