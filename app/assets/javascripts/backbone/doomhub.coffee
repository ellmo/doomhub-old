#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

@Doomhub ?= {}
@Doomhub.Routers ?= {}
@Doomhub.Views ?=
  Maps : {},
  Projects : {}
@Doomhub.Models ?= {}
@Doomhub.Collections ?= {}

$ ->
  init = new Doomhub.Initializer()
