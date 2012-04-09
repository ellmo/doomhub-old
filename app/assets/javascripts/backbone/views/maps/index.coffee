class @Doomhub.Views.Maps.Index extends Backbone.View
  
  events:
    'load': 'asd'

  constructor: () ->
    super
    H.view = @ if H.debug

  asd: (e) ->
    alert 'qwe'
    