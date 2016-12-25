paymentActivations = $('#payment_activations')
paymentActivations.find("a[data-toggle=\"tab\"]").on "shown.bs.tab", (e) ->
  target = $(e.target).attr("href") # activated tab
  href = $(e.target).data("url")
  if $(target).is(":empty")
    $.ajax
      type: "GET"
      url: href
      success: (data) ->
        $(target).html data
        return

  return

paymentActivations.find("a[data-toggle=\"tab\"]:first").tab('show');