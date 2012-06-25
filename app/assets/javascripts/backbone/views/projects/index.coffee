class @Doomhub.Views.Projects.Index extends Doomhub.Views.BASE

  constructor: (options)->
    $('.project-index.project-overview .project-description').jScrollPane()
    super
