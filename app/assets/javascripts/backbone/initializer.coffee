class @Doomhub.Initializer
  constructor: ->
    window.H = new Doomhub.Helper
    H.initializer = @
    @router = new Doomhub.Routers.General()
    @run_backbone H.controller, H.action

  run_backbone: (router, action) ->
    H.log "router: #{router} / action: #{action}"
    if @router[router]
        @router[router](action)