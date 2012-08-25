class @Doomhub.Initializer

  constructor: ->
    window.H = new Doomhub.Helper
    H.initializer = @ if H.debug
    router_name = H.controller.name
    if Doomhub.Routers[router_name]
      router = new Doomhub.Routers[router_name]()
      if router[H.action]
        H.log "controller: #{H.controller.name} / action: #{H.action}"
        router[H.action]()