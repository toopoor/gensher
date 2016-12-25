$('.translation_missing').tooltip()
$(document).on 'click', '[data-data-type=flash]', () ->
  options = $(this).data()
  box = $('#messagebox')
  box[0].className = box[0].className.replace(/alert-(success|danger|warning|info)/g , '')
  box.html(options.text).addClass("alert-" + (options.type || "warning"))
  box.removeClass('hide')
  return false