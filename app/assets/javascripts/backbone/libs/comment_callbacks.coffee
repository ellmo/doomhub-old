class @Doomhub.Libs.CommentCallbacks

#============
#= FUNCTIONS
#==========

  @quote_callback: (event) ->
    event.preventDefault()
    target = $(event.target).closest('a')
    $.getJSON target.attr('href'), (data) ->
      console.log (JST['comments/quote']({comment: data}))

  @delete_callback: (event) ->
    event.preventDefault()
    target = $(event.target).closest('a')
    $.getJSON target.attr('href'), (data) ->
      console.log (JST['comments/quote']({comment: data}))

  @edit_callback: (event) ->
    event.preventDefault()
    target = $(event.target).closest('a')
    $.getJSON target.attr('href'), (data) ->
      console.log (JST['comments/quote']({comment: data}))