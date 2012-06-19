class @Doomhub.Routers.Projects extends Doomhub.Routers.BASE

  index: ->
    H.log 'hello'
    @view ?= new Doomhub.Views.Projects.Index({ el: $('#topmost'), col: @collection })

  new: ->
    @form()

  create: ->
    @form()

  edit: ->
    @form()

  update: ->
    @form()

  form: ->
    @view ?= new Doomhub.Views.Projects.Form({ el: $('#topmost'), col: @collection })