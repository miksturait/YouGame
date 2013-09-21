module ApplicationHelper

  def link_to_icon icon, text, url, opts={}
    link_to url, opts do
      content_tag(:i, '', class: icon) + ' ' +
      text
    end
  end

end
