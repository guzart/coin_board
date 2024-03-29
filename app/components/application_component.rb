class ApplicationComponent < ViewComponent::Base
  extend Dry::Initializer

  option :id, optional: true
  option :class, default: proc { "" }, as: :class_name
  option :data, default: proc { {} }

  private

  def id_with_fallback
    @id_with_fallback ||= id || "component-#{SecureRandom.hex(6)}"
  end
end
