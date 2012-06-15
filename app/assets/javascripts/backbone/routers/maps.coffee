class @Doomhub.Routers.Maps extends Doomhub.Routers.BASE

  index: ()->
    @view ?= new Doomhub.Views.Maps.Index({ el: $('#topmost'), col: @collection })
