class @Doomhub.Views.Projects.Show extends Doomhub.Views.BASE

  events:
    'click .image-div' : 'imageDivClicked'
    'ajax:success form.new_comment' : 'commentCreated'

  constructor: (options) ->
    super
    $('#project-orbit').orbit()
    @ccb = Doomhub.Libs.Comments

  imageDivClicked: (event) ->
    target = $(event.target)
    target_id = target.attr('id')
    window.target = target
    image_height = target.data('originalHeight');
    if $(".reveal-dummies .gallery-image[rel='#{target_id}']").length > 0
      $(".reveal-dummies .gallery-image[rel='#{target_id}']").reveal()
    else
      $.getJSON target.attr('rel'), (data) ->
        auth_url = data['url']
        $('.reveal-dummies').append JST['popups/gallery_image']
          image_url: auth_url,
          image_id: target_id
        $(".reveal-dummies .gallery-image[rel='#{target_id}']").reveal()

  commentCreated: (event, data, status, xhr) ->
    $('#new_comment #comment_content').val ''
    $("#comment-list").html JST["comments/list"]
      comments: data.comments
    location.hash = '#comments/p' + data.pagination.total_pages


