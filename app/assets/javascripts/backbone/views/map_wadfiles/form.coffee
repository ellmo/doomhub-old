class @Doomhub.Views.MapWadfiles.Form extends Doomhub.Views.BASE

  constructor: (options)->
    super
    #$('#map_wadfile_wadfile_wrapper').hide()

    # $('#map_wadfile_wadfile_dummy').file().choose (e, input) ->
    #   $('#map_wadfile_wadfile_wrapper').append(
    #     $(input).attr('id', 'map_wadfile_wadfile').attr('name', 'map_wadfile[wadfile]'))
    #   $('#map_wadfile_wadfile_dummy').attr 'placeholder', input.val().split("\\").pop()