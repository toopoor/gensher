#= require best_in_place
#= require best_in_place.purr
activationRequests = $('#activation-requests')
activationRequests.find("a[data-toggle=\"tab\"]").on "shown.bs.tab", (e) ->
  target = $(e.target).attr("href") # activated tab
  href = $(e.target).data("url")
  $.ajax
    type: "GET"
    url: href
    success: (data) ->
      $(target).html data
      $(target).find('.best_in_place').best_in_place()
      return

  return

activationRequests.find("a[data-toggle=\"tab\"]:first").tab 'show'

$('#activation-request-comment-modal').on 'show.bs.modal', (event) ->
  button = $(event.relatedTarget)
  url = button.data('url')
  modal = $(this)
  form = modal.find('.modal-body form')[0]
  form.action = url

  modal.find('#save_comment').click ->
    form.submit()

$('#activation-request-change-plan-modal').on 'show.bs.modal', (event) ->
  button = $(event.relatedTarget)
  url = button.data('url')
  modal = $(this)
  form = modal.find('.modal-body form')[0]
  form.action = url
  select = modal.find('#plan')
  select.val button.data('plan')

  modal.find('#change_plan').click ->
    form.submit()
