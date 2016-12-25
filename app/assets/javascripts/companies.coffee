#= require bootstrap-star-rating/star-rating.min
#= require bootstrap-star-rating/star-rating_locale_ru


$('.companies__list input.star-rating').rating({
  showCaption: false
  showClear: false
}).on 'rating.change', (event, value, caption) ->
  $(event.target).parents('form').submit()

$('#company-description-modal').on 'show.bs.modal', (event) ->
  button = $(event.relatedTarget)
  description = button.data 'description'
  name = button.data 'name'
  modal = $(@)
  modal.find('.modal-header .modal-title').html name
  modal.find('.modal-body').html description
