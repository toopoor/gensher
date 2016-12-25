#= require best_in_place
#= require best_in_place.purr
voucherRequests = $('#voucher-requests')
voucherRequests.find("a[data-toggle=\"tab\"]").on "shown.bs.tab", (e) ->
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

voucherRequests.find("a[data-toggle=\"tab\"]:first").tab 'show'
