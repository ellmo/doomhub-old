class @Doomhub.Libs.Comments

#============
#= FUNCTIONS
#==========

  @fetchComments: (comments_json_path) ->
    $.getJSON comments_json_path, (data) ->
      $('#comment-list').html(JST['comments/list']({comments: data}))
      $('a[data-action="quote"]').live 'click', Doomhub.Libs.Comments.quote_callback
      $('a[data-action="delete"]').live 'click', Doomhub.Libs.Comments.delete_callback
      $('a[data-action="edit"]').live 'click', Doomhub.Libs.Comments.edit_callback
      $(window).trigger('resize')

  @create_callback: (event, data, status, xhr) ->
    $('#comment-list').html(JST['comments/list'](
        comments: data
      )
    )
    $('#new_comment #comment_content').val ''
    $(window).trigger('resize')

  @quote_callback: (event) ->
    event.preventDefault()
    target = $(event.target).closest 'a'
    destination = $('#new_comment #comment_content')
    if destination
      $.getJSON target.attr('href'), (data) ->
        c = data.comment
        quoted_header = "\n> # _on #{c.human_created_at}, **#{c.user.login}** wrote:_\n>\n"
        quoted_lines = _.map c['raw_content'].split("\n"), (line) -> ("> " + line)
        destination.val(destination.val() + quoted_header + quoted_lines.join("\n"))
        $('#new_comment')[0].scrollIntoView()

  @delete_callback: (event) ->
    event.preventDefault()
    target = $(event.target).closest 'a'
    $('.reveal-dummies').append JST['popups/delete']
      delete_path: target.attr('href')
    $('.reveal-dummies .delete-confirm').reveal
      closed: Doomhub.Libs.Comments.removeDeleteModal;

  @removeDeleteModal: (event)->
    target = event.target;
    $(target).remove()

  @edit_callback: (event) ->
    event.preventDefault()
    console.log event