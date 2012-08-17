class @Doomhub.Routers.MapWadfiles extends Doomhub.Routers.BASE

  index: ()->
    H.log 'not implemented'

  new: ->
    @form()

  form: ()->
    @view ?= new Doomhub.Views.MapWadfiles.Form({ el: $('#topmost'), col: @collection })
