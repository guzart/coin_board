module IconHelper
  def icon(name, animate: nil)
    icon_name = icon_name_for_alias(name).to_s.gsub("_", "-")
    style_classname = "fa-regular"
    icon_classname = "fa-#{icon_name}"
    "<i class='#{style_classname} #{icon_classname} #{icon_animate_classname(animate)}' />".html_safe
  end

  def icon_animate_classname(name)
    "fa-#{name.to_s.gsub('_', '-')}" if name
  end

  def icon_name_for_alias(icon_alias)
    case icon_alias
    when :delete
      :trash
    when :remove
      :trash
    else
      icon_alias
    end
  end
end
