class @Doomhub.Routers.Main extends Backbone.Router

  routes:
    'maps/:action': 'maps'
    'projects/:action': 'projects'

  maps: (action) ->
    @maps_router ?= new Doomhub.Routers.Map()
    @maps_router[action]() if @maps_router[action]?

  projects: (action) ->
    @projects_router ?= new Doomhub.Routers.Project()
    @projects_router[action]() if @projects_router[action]?