class Doomhub.Libs.PaginationHelper

#=======
#= CTOR
#=====

  constructor: (pagination_data)->
    H.pagination_helper = @
    @anchor = location.hash.match(/(#\w*)(\/*[\w\d]*)/)[1]
    @current_url = location.pathname
    @data = pagination_data

#============
#= FUNCTIONS
#==========

  paginate: (el, ul_class="pagination") ->
    $(el).html "<ul class=#{ul_class}></ul>"
    _pagination_ul = $(".#{ul_class}", el)
    _parts = @pagination_parts()
    _.map _parts, (part) ->
      _pagination_ul.append part

  pagination_parts: () ->
    links_hash = []
    links_hash.push @paged_href(1, "«", !@data.first),
      @paged_href(@data.page - 1, "‹", !@data.first)
    if @data.total_pages > 10
      _flat_parts = []
      _.map @relevant_pages(), (page_parts) =>
        unless page_parts.length == 0
          _flat_parts.push(_.map page_parts, (page) =>
            @paged_href page, page, (page != @data.page))
      links_hash.push (_.map _flat_parts, (_fp) ->
        _fp.join('')).join("<li class='not-a'>...</p></li>")
    else
      links_hash.push (_.map [1..@data.total_pages], (page) =>
        @paged_href page, page, (page != @data.page)).join('')
    links_hash.push @paged_href(@data.page + 1, "›", !@data.last),
      @paged_href(@data.total_pages, "»", !@data.last)
    return links_hash

  paged_href: (page, text, link=true) ->
    if link
      "<li><a href='#{@current_url + @anchor + '/p' + page}'>#{text}</a></li>"
    else
      unless isNaN parseInt(text)
        "<li class='current'>#{text}</li>"
      else
        "<li class='not-a'>#{text}</li>"

  relevant_pages: () ->
    total_pages = @data.total_pages
    curr_page = @data.page
    pages_to_end = total_pages - curr_page
    links_left = [1, 2]
    links_right = [total_pages - 1, total_pages]
    links_mid = []
    if curr_page < 5
      links_left.push(3, 4, 5)
    else if (curr_page > 4) and (pages_to_end > 3)
      links_mid.push(curr_page - 1, curr_page, curr_page + 1)
    else if pages_to_end <= 3
      links_right.unshift(total_pages - 4, total_pages - 3, total_pages - 2)
    return [links_left, links_mid, links_right]

