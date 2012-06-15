class @Doomhub.Views.BASE extends Backbone.View

  constructor: (options) ->
    H.view = @ if H.debug
    @options = options