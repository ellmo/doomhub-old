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

  #=========================================
  #= RESPONSIVE AND FOCUSABLE ZURB CHECKBOX
  #=======================================
  zurb_chkboxes = $('form input + .zurb-checkbox-span-thingy')
  for _zurb_chekbox in zurb_chkboxes
    do (_zurb_chekbox) ->
      _zurb_chekbox = $(_zurb_chekbox)
      _zurb_chkbox_input = $("form input[name='#{_zurb_chekbox.attr('rel')}']")
      _zurb_chekbox.keydown (e) ->
        if e.keyCode is 32 or e.keyCode is 13
          e.preventDefault()
          _zurb_chekbox.toggleClass 'checked'
          _zurb_chkbox_input.attr('checked', _zurb_chekbox.is('.checked'));

  #===================
  #= FULL jScrollPane
  #=================

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
      $('#topmost > .jspContainer > .jspPane').css
        width: '100%'
  ).trigger "resize"

  $("body").css
    overflow: 'hidden'
  win.trigger "resize" unless $("#topmost").width() is win.width()

