class ListGroupComponent < ApplicationComponent
  renders_many :items, "ItemComponent"

  slim_template <<~SLIM
    ul[class=root_class id=id data=data]
      - items.each do |item|
        = item
  SLIM

  private

  def root_class
    "list-group #{class_name}"
  end

  class ItemComponent < ApplicationComponent
    param :text, default: proc { nil }

    slim_template <<~SLIM
      li.list-group-item
        = text || content
    SLIM
  end
end
