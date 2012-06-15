class @Doomhub.Views.BASE extends Backbone.View

  events: {}

  constructor: (options) ->
    super
    H.view = @ if H.debug
    @options = options
