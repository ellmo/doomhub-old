class @Doomhub.Views.Uploads.Form extends Doomhub.Views.BASE

  constructor: (options)->
    super
    #$('#upload_wrapper').hide()

    # $('#upload_archive_dummy').file().choose (e, input) ->
    #   $('#upload_wrapper').append(
    #     $(input).attr('id', 'upload_archive').attr('name', 'upload[archive]'))
    #   $('#upload_archive_dummy').attr 'placeholder', input.val().split("\\").pop()