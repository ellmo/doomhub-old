class @Doomhub.Routers.Uploads extends Doomhub.Routers.BASE

  index: ()->
    H.log 'not implemented'

  new: ->
    @form()

  form: ()->
    @view ?= new Doomhub.Views.Uploads.Form({ el: $('#topmost'), col: @collection })
