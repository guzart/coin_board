class CardComponent < ApplicationComponent
  renders_one :title, "TitleComponent"
  renders_many :texts, "TextComponent"

  slim_template <<~SLIM
    div[class=root_class data=data id=id]
      .card-body
        = content
  SLIM

  private

  def root_class
    "card #{class_name}"
  end

  class TitleComponent < ApplicationComponent
    param :text, default: proc { nil }
    option :tag, default: proc { :h5 }

    slim_template <<~SLIM
      *{ tag: tag, class: "card-title" }
        = text || content
    SLIM
  end

  class TextComponent < ApplicationComponent
    param :text, default: proc { nil }

    slim_template <<~SLIM
      p.card-text
        = text || content
    SLIM
  end
end
