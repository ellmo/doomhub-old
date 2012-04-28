class @Doomhub.Routers.Map extends Backbone.Router

  constructor: ()->
    H.router = @ if H.debug
    @collection = new Doomhub.Collections.Map()
  
  index: ()->
    @view ?= new Doomhub.Views.Maps.Index({ el: $('#topmost'), col: @collection })
