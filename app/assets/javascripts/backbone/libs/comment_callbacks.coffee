class @Doomhub.Libs.CommentCallbacks

#============
#= FUNCTIONS
#==========

  @quote_callback: (event) ->
    event.preventDefault()
    target = $(event.target).closest('a')
    $.getJSON target.attr('href'), (data) ->
      tinymce.activeEditor.setContent JST['comments/quote']({comment: data})

  @delete_callback: (event) ->
    event.preventDefault()
    target = $(event.target).closest('a')
    $.getJSON target.attr('href'), (data) ->
      tinymce.activeEditor.setContent JST['comments/quote']({comment: data})

  @edit_callback: (event) ->
    event.preventDefault()
    target = $(event.target).closest('a')
    $.getJSON target.attr('href'), (data) ->
      tinymce.activeEditor.setContent JST['comments/quote']({comment: data})