class @Doomhub.Routers.DeviseRegistrations extends Doomhub.Routers.BASE

  new: ()->
    @view ?= new Doomhub.Views.DeviseRegistrations.New({ el: $('#topmost'), col: @collection })
