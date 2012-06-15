class @Doomhub.Views.Projects.Form extends Doomhub.Views.BASE

  events:
    'keyup input#project_name' : 'on_project_name_change'

  on_project_name_change: (e)->
    input_url_name = $('input#project_url_name')
    if input_url_name.val() == ''
      input_url_name.attr('placeholder', e.target.value)
