class Doomhub.Libs.Comments

#============
#= FUNCTIONS
#==========

  @render: (json_data, pagination_element) ->
    pagination_element = $('pagination-div') unless pagination_element
    $('#comment-list').html(JST['comments/list']({comments: json_data.comments}))
    $('a[data-action="quote"]').on 'click', Doomhub.Libs.Comments.quote_callback
    $('a[data-action="delete"]').on 'click', Doomhub.Libs.Comments.delete_callback
    $('a[data-action="edit"]').on 'click', Doomhub.Libs.Comments.edit_callback
    _pag_helper = new Doomhub.Libs.PaginationHelper(json_data.pagination)
    _pag_helper.paginate(pagination_element)
    $(window).trigger('resize')

  @quote_callback: (event) ->
    event.preventDefault()
    target = $(event.target).closest 'a'
    target.off('click').on 'click', Doomhub.Libs.Comments.dummy_callback
    destination = $('#new_comment #comment_content')
    if destination
      $.getJSON target.attr('href'), (data) ->
        c = data.comment
        quoted_header = "\n> # _on #{c.human_created_at}, **#{c.user.login}** wrote:_\n>\n"
        quoted_lines = _.map c['raw_content'].split("\n"), (line) -> ("> " + line)
        destination.val(destination.val() + quoted_header + quoted_lines.join("\n"))
        $('#new_comment')[0].scrollIntoView()
    setTimeout ->
      target.on 'click', Doomhub.Libs.Comments.quote_callback
    , 100


  @delete_callback: (event) ->
    event.preventDefault()
    target = $(event.target).closest 'a'
    target.off('click').on 'click', Doomhub.Libs.Comments.dummy_callback
    Doomhub.Libs.DeleteModal.open(event)
    setTimeout ->
      target.on 'click', Doomhub.Libs.Comments.delete_callback
    , 100

  @edit_callback: (event) ->
    event.preventDefault()
    target = $(event.target).closest 'a'
    div = $(event.target).closest '.comment-div'
    if $('form.edit_comment', div).length is 0
      $.getJSON target.attr('href'), (data) ->
        c = data.comment
        div.append JST['comments/form']
          url: c.path,
          content: c.raw_content
        $(window).trigger('resize')
        $('form.edit_comment').live 'ajax:success', (event, data) ->
          div.html JST['comments/single']( comment: data.comment )

  @dummy_callback: (event) ->
    event.preventDefault()
    return true