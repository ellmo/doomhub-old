class DoomhubBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
  def render
    @context.content_tag(:ul, class: 'breadcrumbs') do
      @elements.collect do |element|
        render_element(element)
      end.join.html_safe
    end
  end

  def render_element(element)
    current = @context.current_page?(compute_path(element))
    allowed = (element.options.delete :allowed) != false
    force = !!(element.options.delete :force)

    @context.content_tag(:li, :class => ('current' if current and !force)) do
      link_or_text = ''
      if allowed
        unless force
          link_or_text = @context.link_to_unless_current(compute_name(element), compute_path(element), element.options)
        else
          link_or_text = @context.link_to(compute_name(element), compute_path(element), element.options)
        end
      else
        link_or_text = @context.content_tag(:span, compute_name(element)).html_safe
      end
      divider = @context.content_tag(:span, (@options[:separator]  || ' &raquo; ').html_safe) unless current and !force

      link_or_text + (divider || '')
    end
  end
end