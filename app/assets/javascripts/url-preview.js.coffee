resizeIframe = (iframe) ->
  width = parseFloat iframe.width(), 10
  height = parseFloat iframe.height(), 10
  ratio = height / width
  containerWidth = iframe.parent('.js-url-preview').width()

  iframe.width(containerWidth)
  iframe.height(containerWidth * ratio)

$(document).ready ->
  $('.js-url-preview iframe').each -> resizeIframe $(this)
