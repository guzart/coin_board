module ButtonAppearanceProps
  extend ActiveSupport::Concern

  included do
    # :primary, :secondary, :success, :danger, :warning, :info, :light, :dark
    option :variant, default: proc { :primary }

    option :outline, optional: true, default: proc { false }

    # :sm, :lg
    option :size, optional: true, default: proc { nil }

    private

    def button_appearance_props
      { variant:, outline:, size: }
    end

    def appearance_class_names
      "#{variant_appearance_class} #{size_appearance_class}"
    end

    def variant_appearance_class
      outline_prefix = outline ? "-outline" : ""
      "btn#{outline_prefix}-#{variant}"
    end

    def size_appearance_class
      "btn-#{size}" if size.present?
    end
  end
end
