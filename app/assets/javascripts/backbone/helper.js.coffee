class @Doomhub.Helper
  constructor: ->
    _.extend(@, Backbone.Events)
    @controller = $('body').data('controller')
    @action = $('body').data('action')
    @debug = $('body').data('debug')

  log: (obj)->
    console.log(obj)

  timestamp: ()->
    new Date().getTime()