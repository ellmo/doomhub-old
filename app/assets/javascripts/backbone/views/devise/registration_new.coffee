class @Doomhub.Views.DeviseRegistrations.New extends Doomhub.Views.BASE

  events:
    'click a#eula-link' : 'toggleEula'

  toggleEula: (e)->
    e.preventDefault();
    if $('#eula').size() < 1
      $('.reveal-dummies').append JST['legal']
    $('#eula').reveal
      opened: @eulaRevealed
    $(window).resize ->
      $('#legal-container').jScrollPane()

  eulaRevealed: ->
    $('#legal-container').jScrollPane()