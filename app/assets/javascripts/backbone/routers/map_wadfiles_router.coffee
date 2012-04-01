class @Doomhub.Routers.Map extends Backbone.Router
  
  index_action: ()->
    @view ?= new Doomhub.Views.Maps.Index({ el: $('#topmost') })
