class ApplicationComponent < ViewComponent::Base
  extend Dry::Initializer

  option :id, optional: true
  option :class, default: proc { "" }, as: :class_name
end
