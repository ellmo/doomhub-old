class @Doomhub.Routers.Projects extends Doomhub.Routers.BASE

  routes:
    'projects/new': 'new'

  index: ()->
    H.log('hello')
    @view ?= new Doomhub.Views.Projects.Index({ el: $('#topmost'), col: @collection })

  new: ()->
    H.log('tryin` to add-a new project now, are ya?' )
    @view ?= new Doomhub.Views.Projects.New({ el: $('#topmost'), col: @collection })