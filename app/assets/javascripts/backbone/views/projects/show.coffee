class @Doomhub.Views.Projects.Show extends Doomhub.Views.BASE

  events:
    'click .image-div' : 'imageDivClicked'
    'ajax:success form.new_comment' : 'formCreated'

  constructor: (options) ->
    super
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

  formCreated: (event, data, status, xhr) ->
    console.log(data);
    $('#comment-list').html(JST['comments/list']({comments: data}))