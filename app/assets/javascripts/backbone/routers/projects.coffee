class @Doomhub.Routers.Projects extends Doomhub.Routers.BASE

  routes:
    '' : 'overview'
    'overview' : 'overview'
    'comments' : 'comments'
    'maps' : 'maps'
    'images' : 'images'
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
    @view ?= new Doomhub.Views.Projects.Show({ el: $('#topmost'), col: @collection })

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

  comments: ->
    @ztb.switch_to_tab('comments')

  maps: ->
    @ztb.switch_to_tab('maps')

  images: ->
    @ztb.switch_to_tab('images')

  resources: ->
    @ztb.switch_to_tab('resources')


