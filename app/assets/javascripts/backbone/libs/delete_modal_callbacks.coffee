class Doomhub.Libs.DeleteModal

#============
#= FUNCTIONS
#==========

  @open: (event) ->
    target = $(event.target).closest 'a'
    delete_path = target.attr 'href'
    _tmp = delete_path.split '/'
    _tmp.pop()
    reload_path = _tmp.join '/'
    $('.reveal-dummies').append JST['popups/delete']
      delete_path: delete_path,
      reload_path: reload_path
    $('.reveal-dummies #reveal-no').click Doomhub.Libs.DeleteModal.close
    $('.reveal-dummies #reveal-yes').click Doomhub.Libs.DeleteModal.confirm
    $('.reveal-dummies .delete-confirm').reveal
      closed: Doomhub.Libs.DeleteModal.removeDeleteModal;

  @close: (event) ->
    $('.reveal-modal.delete-confirm').trigger('reveal:close');

  @confirm: (event) ->
    deleteUrl = $('.reveal-modal.delete-confirm').data('path')
    reloadUrl = $('.reveal-modal.delete-confirm').data('reload')
    $.ajax
      url: deleteUrl,
      type: 'DELETE',
      dataType: 'json',
      success: (result, status) ->
        Doomhub.Libs.Comments.render(result)
        Doomhub.Libs.DeleteModal.close()
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        Doomhub.Libs.DeleteModal.close()

  @removeDeleteModal: (event)->
    target = event.target;
    $(target).remove()
