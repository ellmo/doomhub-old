class @Doomhub.Helper
  constructor: ->
    # get the params hash returned by Rails' server
    # and filtered by SafeParams lib
    @params = $('body').data("params")

    # pick the most important values from params hash
    @controller =
      name: @params.controller.toCamel(),
      route: @params.controller[0]
    @parents = []
    if @params.project_id
      @parents.push
        id: @params.project_id,
        route: 'p'
    if @params.map_id
      @parents.push
        id: @params.map_id,
        route: 'm'
    @action = @params.action
    @id = @params.id

    # is debug mode on?
    # (debug is outside request params)
    @debug = $('body').data("debug")

  log: (obj)->
    console.log(obj) if @debug

  timestamp: ()->
    new Date().getTime()