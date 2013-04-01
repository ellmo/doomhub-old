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
    _pagination_ul.append _parts.first
    _pagination_ul.append _parts.prev
    _.map _parts.pages, (link) =>
      _pagination_ul.append link
    _pagination_ul.append _parts.next
    _pagination_ul.append _parts.last

  pagination_parts: () ->
    links_hash =
      first: @paged_href(1, "«", !@data.first),
      prev: @paged_href(@data.page - 1, "‹", !@data.first),
      next: @paged_href(@data.page + 1, "›", !@data.last),
      last: @paged_href(@data.total_pages, "»", !@data.last)
    links_hash['pages'] = _.map @relevant_pages(), (page) =>
      @paged_href page, page
    return links_hash

  paged_href: (page, text, link=true) ->
    if link
      "<li><a href='#{@current_url + @anchor + '/p' + page}'>#{text}</a></li>"
    else
      "<li>#{text}</li>"

  relevant_pages: () ->
    if parseInt(@data.total_pages) < 9
      pages = []
    else
      pages = _.map [1..@data.total_pages], (page) ->
        page
    return pages
