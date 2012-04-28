class @Doomhub.Initializer
  constructor: ->
    # helper'sposed to be accessible through console
    window.H = new Doomhub.Helper

    # make the Initializer accessible through the console
    # ...if debug is true
    H.initializer = @ if H.debug

    # get the Main router and fire everything up
    @router = new Doomhub.Routers.Main()
    @run_backbone H.controller, H.action

  # reroute to specific Router and it's Action
  run_backbone: (router, action) ->
    H.log "router: #{router} / action: #{action}"
    if @router[router]
        @router[router](action)