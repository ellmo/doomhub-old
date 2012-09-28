class @Doomhub.Libs.ZurbTabFunctions

#============
#= FUNCTIONS
#==========

  clear_tabs: ->
    $('.nice.contained.tabs dd a').removeClass('active')
    $('ul.nice.contained.tabs-content > li').hide().removeClass('active')

  show_tab: (element_id) ->
    $(".nice.contained.tabs dd a[href='##{element_id}']").addClass('active')
    $("ul.nice.contained.tabs-content > li##{element_id}Tab").show().addClass('active')
    $(window).trigger('resize');

  switch_to_tab: (element_id) ->
    @clear_tabs()
    @show_tab(element_id)