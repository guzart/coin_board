class ListGroupComponent < ApplicationComponent
  renders_many :items, lambda { |content = nil, &block|
    content_tag :li, content, class: "list-group-item", &block
  }

  slim_template <<~SLIM
    = content_tag :ul, class: root_class, id:, data: do
      - items.each do |item|
        = item
  SLIM

  private

  def root_class
    "list-group #{class_name}"
  end
end
