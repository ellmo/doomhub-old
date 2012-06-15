class @Doomhub.Views.BASE extends Backbone.View

  constructor: (options) ->
    super
    H.view = @ if H.debug
    @options = options
