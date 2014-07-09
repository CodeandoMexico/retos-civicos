openAlertMessage = ->
  $('.js-alert-message').each ->
    modal = $(this)
    unless wasAlerted()
      modal.modal('show')
      recordAlert()

wasAlerted = ->
  localStorage.wasAlerted

recordAlert = ->
  localStorage.wasAlerted = true

$(document).ready ->
  setTimeout(openAlertMessage, 300)
