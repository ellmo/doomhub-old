class @Doomhub.Routers.BASE extends Backbone.Router

  constructor: ()->
    super
    H.router = @ if H.debug
    # H.log "trying to start BB history"
    # if Backbone.history
    #   Backbone.history.start()
    #   H.history = Backbone.history
    #   H.log "BB history started"
