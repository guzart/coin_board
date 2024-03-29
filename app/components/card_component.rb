class CardComponent < ApplicationComponent
  renders_one :title, lambda { |content = nil, tag: :h5, &block|
    content_tag(tag, content, class: "card-title", &block)
  }
  renders_many :texts, lambda { |content = nil, &block|
    content_tag(:p, content, class: "card-text", &block)
  }

  slim_template <<~SLIM
    = content_tag :div, class: root_class, data:, id: do
      .card-body
        = content
  SLIM

  private

  def root_class
    "card #{class_name}"
  end
end
