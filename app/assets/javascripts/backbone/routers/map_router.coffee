class @Doomhub.Routers.Map extends Backbone.Router

  constructor: ()->
    H.router = @ if H.debug
  
  index: ()->
    @view ?= new Doomhub.Views.Maps.Index({ el: $('#topmost') })
