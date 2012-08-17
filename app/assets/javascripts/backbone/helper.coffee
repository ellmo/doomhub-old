class @Doomhub.Helper
  constructor: ->
    # get the params hash returned by Rails' server
    # and filtered by SafeParams lib
    @params = $('body').data("params")

    # pick the most important values from params hash
    @controller = @params.controller
    @action = @params.action.toLowerCase()

    # is debug mode on?
    # (debug is outside request params)
    @debug = $('body').data("debug")

  log: (obj)->
    console.log(obj) if @debug

  timestamp: ()->
    new Date().getTime()