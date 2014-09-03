fillBars = (bars) ->
  return if bars.length == 0
  bar = $(bars.shift())
  bar.height(size(bar))
  bar.width(size(bar))
  setTimeout (-> fillBars(bars)), transitionDurationMilliseconds(bar)

size = (bar) ->
  "#{bar.data('size')}%"

transitionDurationMilliseconds = (bar) ->
  parseFloat(bar.css('transition-duration')) * 1000

$(document).ready ->
  bars = $('.js-phases-bar [data-size]')
  setTimeout (-> fillBars(bars.toArray())), 100
