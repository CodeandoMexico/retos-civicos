window.start_spinner = ($element) ->

  $element ?= $(window)

  radius = 10
  top_position = "#{(($element).height() / 2) - (radius / 2) + $element.scrollTop()}"
  opts = {
    lines: 13, # The number of lines to draw
    length: 7, # The length of each line
    width: 4, # The line thickness
    radius: radius, # The radius of the inner circle
    corners: 1, # Corner roundness (0..1)
    rotate: 0, # The rotation offset
    color: '#000', # #rgb or #rrggbb
    speed: 1, # Rounds per second
    trail: 60, # Afterglow percentage
    shadow: false, # Whether to render a shadow
    hwaccel: false, # Whether to use hardware acceleration
    className: 'spinner', # The CSS class to assign to the spinner
    zIndex: 2e9, # The z-index (defaults to 2000000000)
    top: top_position, # Top position relative to parent in px
    left: 'auto' # Left position relative to parent in px
  }

  target = $('body')[0]
  spinner = new Spinner(opts).spin(target)
  
window.stop_spinner = ->
  $(".spinner").remove()

$(document).ajaxStart ->
  window.start_spinner()

$(document).ajaxStop ->
  window.stop_spinner()
