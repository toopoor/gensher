#= require jquery.Jcrop
#= require jquery-fileupload
#= require best_in_place
#= require best_in_place.purr
window.AvatarCrop = (($, w, undefined_) ->
  w.$apiCrop = undefined_
  $cropModal = $cropForm = undefined_
  $baseW = $baseH = $set = undefined_

  avatarCrop = ->
    $cropModal = $('#avatar-crop-modal')
    $cropForm = $cropModal.find('#crop_avatar_form')
    avatarTarget = $('#avatar-target')
    $baseW = avatarTarget.data 'w'
    $baseH = avatarTarget.data 'h'
    baseR = (if $baseW > $baseH then $baseH else $baseW)
    x = ($baseW-baseR)/2
    y = ($baseH-baseR)/2
    x2 = $baseW+x
    y2 = $baseW+y
    set = [x,y,x2,y2]

    avatarTarget.Jcrop
      onChange: updateCrop
      onSelect: updateCrop
      setSelect: set
      aspectRatio: 1
    , ->
      w.$apiCrop = this

  updateCrop = (c) ->
    $cropModal.find('#avatar-thumb, #avatar-icon').each ->
      prev = $(this)
      prevW = prev.data 'w'
      prevH = prev.data 'h'
      rx = prevW/c.w
      ry = prevH/c.h

      prev.css
        width: Math.round(rx * $baseW) + "px"
        height: Math.round(ry * $baseH) + "px"
        marginLeft: "-" + Math.round(rx * c.x) + "px"
        marginTop: "-" + Math.round(ry * c.y) + "px"


    $cropForm.find('#crop_x').val c.x
    $cropForm.find('#crop_y').val c.y
    $cropForm.find('#crop_w').val c.w;
    $cropForm.find('#crop_h').val c.h

  init: ->
    avatarCrop()

)(jQuery, window)

$('.best_in_place').best_in_place()
$('.expand.empty').click (e) ->
  e.preventDefault()

$cropModal = $('#avatar-crop-modal')
$('#avatar_form').fileupload
  dataType: "json"
  autoUpload: true
  uploadTemplateId: null
  downloadTemplateId: null
  progressall: (e, data) ->
    progress = parseInt(data.loaded / data.total * 100, 10)
    $('.progress').find('.progress-bar').css 'width', progress + '%'
    return

  done: (e, data) ->
    $('.progress').find('.progress-bar').css 'width', '0%'
    updateImgs data.result.avatar.source, false
    return

$cropModal.find('button#save_crop').click ->
  $cropModal.find('#crop_avatar_form').submit()

$('#remove_avatar').click (e)->
  e.preventDefault()
  removeAvatar = $('#user_remove_avatar')
  removeAvatar.val 'true'
  $('#edit_avatar').remove()
  removeAvatar.parents('form').submit()

$('#avatar_form, #crop_avatar_form').each ->
  $(this).bind "ajax:success", (e, data, status, xhr) ->
    if 'success' is status
      removeAvatar = $('#user_remove_avatar')
      removeAvatar.val 'false' if !!removeAvatar.val()
      updateImgs data.avatar.source, $(this).parents('.modal-content').length > 0

updateImgs = (data, hide) ->
  $apiCrop.destroy() if $apiCrop
  source = data
  thumb = data.thumb
  icon = data.icon
  $cropModal.find('.close').trigger('click') if hide

  $('#avatar').attr 'src', thumb.url+'?'+Math.floor(Math.random() * 100000)
  sourceUrl = source.url+'?'+Math.floor(Math.random() * 100000)
  $cropModal.find('.avatar-target img').attr('src', sourceUrl).data(
    w: source.w
    h: source.h
  ).css
    width: source.w + "px"
    height: source.h + "px"
  $cropModal.find('.avatar-thumb img').attr('src', sourceUrl).data(
    w: thumb.w
    h: thumb.h
  ).css
    width: thumb.w + "px"
    height: thumb.h + "px"
  $cropModal.find('.avatar-icon img').attr('src', sourceUrl).data(
    w: icon.w
    h: icon.h
  ).css
    width: icon.w + "px"
    height: icon.h + "px"

  if data.w > 0
    $cropModal.modal('show') unless hide
    setTimeout('AvatarCrop.init()', 800)

AvatarCrop.init()


window.ChangeUserPlan = (($, w, undefined_) ->
  open = ->
    $('#activation_note').removeClass('hidden')
  open: (event) ->
    open()

  skip: (event) ->
    event.preventDefault()
    open()

  voucher: (event) ->
    event.preventDefault()
    $('#voucher_note').removeClass('hidden')

)(jQuery, window)

window.ActivationRequestForm = (($, w, undefined_) ->
  showForm = ->
    $('#activation_request_form').removeClass('hidden')

  hideBtn = ->
    $('#activation_request_btn').addClass('hidden')

  openForm = (event) ->
    event.preventDefault()
    showForm()
    hideBtn()

  changePay = (pay) ->
    $('#activation_request_form').find('#activation_request_pay_system').val pay
    $('#activation_request_form').find('.pay-system').removeClass 'active'
    $('#activation_request_form').find('.pay-system.'+pay).addClass 'active'

  open: (event) ->
    openForm event

  change: (pay) ->
    changePay pay
)(jQuery, window)