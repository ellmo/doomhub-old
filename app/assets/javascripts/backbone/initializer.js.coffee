class @Doomhub.Initializer
  constructor: ->
    window.H = new @.Helper()

    controller_name = $('body').data('controller')
    action_name = $('body').data('action')
    
    #current_controller = new Appname.controllers[controller_name]()
    #current_controller["#{action_name}_action"]()