renderer = Redcarpet::Render::HTML.new({:filter_html => true, :hard_wrap => true})

MD = Redcarpet::Markdown.new renderer,
     :autolink => true,
     :space_after_headers => true,
     :strikethrough => true