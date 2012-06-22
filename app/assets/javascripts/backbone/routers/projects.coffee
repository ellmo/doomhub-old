class @Doomhub.Routers.Projects extends Doomhub.Routers.BASE

  routes:
    '' : 'overview'
    'overview' : 'overview'
    'maps' : 'maps'
    'resources' : 'resources'

  constructor: ->
    @ztb = new Doomhub.Libs.ZurbTabFunctions()
    super

#================
#= RAILS ACTIONS
#==============

  index: ->
    H.log 'hello'
    @view ?= new Doomhub.Views.Projects.Index({ el: $('#topmost'), col: @collection })

  show: ->

  new: ->
    @form()

  create: ->
    @form()

  edit: ->
    @form()

  update: ->
    @form()

  form: ->
    @view ?= new Doomhub.Views.Projects.Form({ el: $('#topmost'), col: @collection })

#============
#= FRAGMENTS
#==========

  overview: ->
    @ztb.switch_to_tab('overview')

  maps: ->
    @ztb.switch_to_tab('maps')

  resources: ->
    @ztb.switch_to_tab('resources')


