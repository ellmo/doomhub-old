class @Doomhub.Initializer
  constructor: ->
    window.H = new Doomhub.Helper
    H.initializer = @ if H.debug
    router_name = H.controller.charAt(0).toUpperCase() + H.controller.slice(1)
    if Doomhub.Routers[router_name]
      router = new Doomhub.Routers[router_name]()
      if router[H.action]
        H.log "controller: #{H.controller} / action: #{H.action}"
        router[H.action]()