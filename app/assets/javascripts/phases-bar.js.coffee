fillBars = (bars) ->
  return if bars.length == 0
  bar = $(bars.shift())
  bar.width(width(bar))
  setTimeout (-> fillBars(bars)), transitionDurationMilliseconds(bar)

width = (bar) ->
  "#{bar.data('width')}%"

transitionDurationMilliseconds = (bar) ->
  parseFloat(bar.css('transition-duration')) * 1000

$(document).ready ->
  bars = $('.js-phases-bar [data-width]')
  setTimeout (-> fillBars(bars.toArray())), 100
