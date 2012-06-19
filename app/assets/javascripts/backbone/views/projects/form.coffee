class @Doomhub.Views.Projects.Form extends Doomhub.Views.BASE

  events:
    'keyup input#project_name' : 'refresh_project_url_name_placeholder'
    'focus input#project_url_name' : 'refresh_project_url_name_placeholder'
    'blur input#project_url_name' : 'refresh_project_url_name_placeholder'

  refresh_project_url_name_placeholder: (e)->
    $('input#project_url_name').attr('placeholder', $('input#project_name').val())