adjustChallengeProfileHeight = (master, slave) ->
  if master and slave
    slave.height master.outerHeight()

    isFontRendered ->
      slave.height master.outerHeight()

isFontRendered = (callback) ->
  setTimeout callback, 100

$(document).ready ->
  adjustChallengeProfileHeight(
    $('.js-challenge-profile-height-master'),
    $('.js-challenge-profile-height-slave'))
