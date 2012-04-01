class @Doomhub.Initializer
  constructor: ->
    window.H = new Doomhub.Helper
    H.initializer = @
    #start_router = new @.Routers.General
    H.log H.controller
    H.log H.action
    @run #H.controller, H.action

  run: ->
    H.log "dupa"
    # H.log "Backbone started for: #{router}/#{action}"
    # router_name = router.charAt(0).toUpperCase() + router.slice(1)
    # false