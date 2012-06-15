#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Doomhub =
  Routers: {}
  Views:
    Maps: {}
    Projects : {}
  Models: {}
  Collections: {}

$ ->
  init = new Doomhub.Initializer()
