#= require_self
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
    DeviseRegistrations: {}
  Models: {}
  Collections: {}
  Libs: {}

$ ->
  init = new Doomhub.Initializer()
  $(document).tooltips();

#=========================================
#= RESPONSIVE AND FOCUSABLE ZURB CHECKBOX
#=======================================
  zurb_chkboxes = $('form input + .zurb-checkbox-span-thingy')
  for _zurb_chekbox in zurb_chkboxes
    do (_zurb_chekbox) ->
      _zurb_chekbox = $(_zurb_chekbox)
      _zurb_chkbox_input = $("form input[name='#{_zurb_chekbox.attr('rel')}']")
      _zurb_chekbox.live "keydown", (e) ->
        if e.keyCode is 32 or e.keyCode is 13
          e.preventDefault()
          _zurb_chekbox.toggleClass 'checked'
          _zurb_chkbox_input.val( if $(e.target).is('.checked') then "1" else "0");

      _zurb_chekbox.live "click", (e) ->
        _zurb_chkbox_input.val( if $(e.target).is('.checked') then "0" else "1");