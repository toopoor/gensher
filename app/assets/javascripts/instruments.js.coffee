$('#yt-video-modal').on 'show.bs.modal', (event) ->
  console.log event
  preview = $(event.relatedTarget)
  videoId = preview.data('video')
  title   = preview.data('title')
  modal = $(this)
  headerTitle = modal.find('.modal-header .modal-title')
  headerTitle.html title
  frame = modal.find('.modal-body iframe')
  frame.attr('src', 'https://www.youtube.com/embed/'+videoId)
  return