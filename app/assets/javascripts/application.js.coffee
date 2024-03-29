# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery.tokeninput
#= require jquery-ui/widgets/datepicker
#= require jquery.jtruncate.pack
#= require spin
#= require chosen.jquery
#= require bootstrap/modal
#= require bootstrap/dropdown
#= require bootstrap/tab
#= require bootstrap/tooltip
#= require bootstrap/collapse
#= require bootstrap/alert
#= require bootstrap/popover
#= require angular
#= require angular-animate
#= require_tree .
#= require_self
#= require moment
#= require bootstrap-daterangepicker

$(document).ready ->
  $('.dropdown-toggle').dropdown()
  $('.js-chosen').chosen()
  $('.js-datepicker').datepicker(dateFormat: 'yy-mm-dd')
  $('[data-toggle="tooltip"]').tooltip()
  $(".challenge-index-title").fitText 1.4, maxFontSize: "16px"
  $("#challenge-prize-description").fitText 1.2, maxFontSize: "17px"

  $('#player-trigger').on 'click', ->
    $('#modal-player').modal('toggle')
    false

  # Stop video when closing the modal
  $('#modal-player').on 'hidden.bs.modal', ->
    $("#modal-player iframe").attr("src", $("#modal-player iframe").attr("src"))

  # for the scroller to work on each element it has to be registered
  # scroll from source to destination
  scroller('#active_challenges', '#challenges__container') # source, destination
