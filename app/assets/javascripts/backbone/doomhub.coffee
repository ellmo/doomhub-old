#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers
#= require_tree ./libs

window.Doomhub =
  Routers: {}
  Views:
    Maps: {}
    Projects: {}
    MapWadfiles: {}
  Models: {}
  Collections: {}
  Libs: {}

$ ->
  init = new Doomhub.Initializer()
  win = $(window)
  isResizing = false
  win.bind("resize", ->
    unless isResizing
      isResizing = true
      container = $("#topmost")
      container.css
        width: 1
        height: 1

      container.css
        width: win.width()
        height: win.height()

      isResizing = false
      container.jScrollPane()
  ).trigger "resize"
  $("body").css "overflow", "hidden"
  win.trigger "resize"  unless $("#topmost").width() is win.width()
