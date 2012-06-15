class @Doomhub.Routers.BASE extends Backbone.Router

  routes:
    '' : 'index'

  constructor: ()->
    H.router = @ if H.debug
    # H.log "trying to start BB history"
    # unless Backbone.history
    #   Backbone.history = new Backbone.History()
    #   Backbone.history.start()
    #   H.log "BB history started"

