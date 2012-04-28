class @Doomhub.Helper
  constructor: ->
    _.extend(@, Backbone.Events)
    @params = $('body').data("params")
    @controller = @params.controller
    @action = @params.action
    @debug = $('body').data("debug")

  log: (obj)->
    console.log(obj) if @debug

  timestamp: ()->
    new Date().getTime()