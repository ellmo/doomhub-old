class @Doomhub.Views.Projects.Show extends Doomhub.Views.BASE

  events:
    'click .image-div' : 'imageDivClicked'
    'ajax:success form.new_comment' : 'commentCreated'

  constructor: (options) ->
    super
    @ccb = Doomhub.Libs.Comments
    @ccb.fetchComments("/p/#{H.id}/c.json")
    $('#project-orbit').orbit()

  imageDivClicked: (event) ->
    target = $(event.target)
    target_id = target.attr('id')
    window.target = target
    image_height = target.data('originalHeight');
    if $(".reveal-dummies .reveal-modal[rel='#{target_id}']").length > 0
      $(".reveal-dummies .reveal-modal[rel='#{target_id}']").reveal()
    else
      $.getJSON target.attr('rel'), (data) ->
        auth_url = data['url']
        $('.reveal-dummies').append JST['image_popup']( image_url: auth_url, image_id: target_id )
        $(".reveal-dummies .reveal-modal[rel='#{target_id}']").reveal()

  commentCreated: (event, data, status, xhr) ->
    @ccb.create_callback(event, data, status, xhr)

