class @Doomhub.Routers.General extends Backbone.Router

  routes:
    'maps/:action': 'maps'

  maps: (action) ->
    H.log(action)
    @maps_router ?= new Doomhub.Routers.Map()
    @maps_router[action]() if @maps_router[action]?