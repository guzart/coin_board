module ButtonContentProps
  extend ActiveSupport::Concern

  included do
    param :text, optional: true, default: proc { nil }
    option :type, default: proc { :button }
    option :href, default: proc { nil }

    private

    alias_method :original_content, :content

    def link?
      href.present?
    end

    def content
      return text if text.present?

      original_content
    end
  end
end
