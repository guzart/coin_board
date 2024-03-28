module IconHelper
  def icon(name, animate: nil)
    style_classname = "fa-regular"
    icon_classname = "fa-#{name}"
    content_tag(:i, nil, class: [style_classname, icon_classname, icon_animate_classname(animate)].compact.join(" "))
  end

  def icon_animate_classname(name)
    "fa-#{name.to_s.gsub('_', '-')}" if name
  end
end
