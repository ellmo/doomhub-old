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

  #=========================================
  #= RESPONSIVE AND FOCUSABLE ZURB CHECKBOX
  #=======================================
  zurb_chkbox = $('form input + .zurb-checkbox-span-thingy')
  zurb_chkbox_input = $("form input[name='#{zurb_chkbox.attr('rel')}']")
  window.zrb = zurb_chkbox_input
  zurb_chkbox.keydown (e) ->
    if e.keyCode is 32 or e.keyCode is 13
      zurb_chkbox.toggleClass 'checked'
      zurb_chkbox_input.attr('checked', zurb_chkbox.is('.checked'));



  $("body").css
    overflow: 'hidden'
  win.trigger "resize" unless $("#topmost").width() is win.width()

