class @Doomhub.Routers.Projects extends Doomhub.Routers.BASE

  routes:
    '' : 'overview'
    'overview' : 'overview'
    'comments' : 'comments'
    'comments/p:page' : 'comments'
    'comments/:id' : 'comment'
    'maps' : 'maps'
    'images' : 'images'
    'resources' : 'resources'

  constructor: ->
    @ztb = new Doomhub.Libs.ZurbTabFunctions()
    @ccb = Doomhub.Libs.Comments
    @params = {}
    super

#================
#= RAILS ACTIONS
#==============

  index: ->
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

  comments: (page)->
    comment_data = @ccb.fetch "/p/#{H.id}/c.json", {page: page}, $('.pagination-div')
    @ztb.switch_to_tab 'comments'

  comment: (id)->
    @ztb.switch_to_tab('comments', {id: id})

  maps: ->
    @ztb.switch_to_tab('maps')

  images: ->
    @ztb.switch_to_tab('images')

  resources: ->
    @ztb.switch_to_tab('resources')


