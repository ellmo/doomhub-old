class Doomhub.Libs.ZurbTabFunctions

#============
#= FUNCTIONS
#==========

  clear_tabs: ->
    $('.nice.contained.tabs dd a').removeClass('active')
    $('ul.nice.contained.tabs-content > li').hide().removeClass('active')

  show_tab: (element_id) ->
    $(".nice.contained.tabs dd##{element_id} a").addClass('active')
    $("ul.nice.contained.tabs-content > li##{element_id}Tab").show().addClass('active')
    $(window).trigger('resize');

  switch_to_tab: (element_id, params, pagination_data, pagination_callback) ->
    @clear_tabs()
    if pagination_data
      @handle_pagination(pagination_data, pagination_callback)
    @show_tab(element_id)

  handle_pagination: (pagination_data, pagination_callback) ->
    console.log pagination_data
    $('#navbar dd.paginated#comments .page').html(
      "#{pagination_data.page}/#{pagination_data.total_pages}")
    $('#navbar dd.paginated').width('')
    $('#navbar dd.paginated#comments .page').show()
    $('#navbar dd.paginated').width(
      $('#navbar dd.paginated').width() + 2 + $('#navbar dd.paginated#comments .page').width())
    pagination_callback(pagination_data.page)