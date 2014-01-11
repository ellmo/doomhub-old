class @Doomhub.Routers.Maps extends Doomhub.Routers.BASE

  routes:
    '' : 'overview'
    'overview' : 'overview'
    'uploads' : 'uploads'
    'screens' : 'screens'

  constructor: ->
    @ztb = new Doomhub.Libs.ZurbTabFunctions()
    super

#================
#= RAILS ACTIONS
#==============

  index: ()->
    @view ?= new Doomhub.Views.Maps.Index({ el: $('#topmost'), col: @collection })

#============
#= FRAGMENTS
#==========

  overview: ->
    @ztb.switch_to_tab('overview')

  uploads: ->
    @ztb.switch_to_tab('uploads')

  screens: ->
    @ztb.switch_to_tab('screens')