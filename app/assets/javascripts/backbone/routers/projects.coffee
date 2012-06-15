class @Doomhub.Routers.Projects extends Doomhub.Routers.BASE

  index: ->
    H.log 'hello'
    @view ?= new Doomhub.Views.Projects.Index({ el: $('#topmost'), col: @collection })

  new: ->
    H.log 'tryin` to add-a new project now, are ya?'
    @form()

  create: ->
    H.log 'tryin` to add-a new project now, are ya?'
    @form()

  form: ->
    @view ?= new Doomhub.Views.Projects.Form({ el: $('#topmost'), col: @collection })