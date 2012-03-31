#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Doomhub =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

$ ->
  Doomhub.Initializer()